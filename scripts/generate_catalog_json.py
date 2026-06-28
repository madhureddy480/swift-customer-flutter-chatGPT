#!/usr/bin/env python3
"""Generate catalog JSON fixtures from seed CSV files.

Output mirrors DrSwift-CMS GET /api/v1/public/catalog response shape so the
Flutter app can swap asset loading for HTTP later without model changes.
"""

from __future__ import annotations

import csv
import json
import re
from collections import OrderedDict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT_DIR = ROOT / "assets" / "data"
TEST_LIST_CSV = ROOT / "Test List-Table 1.csv"
CATEGORY_CSV = ROOT / "Category List-Table 1.csv"
PROFILES_CSV = ROOT / "Profiles-Table 1.csv"

DEFAULT_IMAGE = (
    "https://images.pexels.com/photos/3786157/pexels-photo-3786157.jpeg"
    "?auto=compress&cs=tinysrgb&w=800"
)

# Stable placeholder prices (rupees) until CMS API is wired in the mobile app.
PRICE_BY_CODE: dict[str, int] = {
    "DRS002": 499,
    "DRS011": 299,
    "DRS024": 399,
    "DRS035": 149,
    "DRS036": 249,
    "DRS041": 199,
    "DRS048": 299,
    "DRS056": 99,
    "DRS061": 399,
    "DRS062": 399,
    "DRS065": 349,
    "DRS066": 149,
    "DRS075": 499,
    "DRS076": 499,
    "DRS077": 399,
    "DRS078": 599,
    "DRS080": 399,
    "DRS081": 199,
    "DRS082": 499,
    "DRS087": 399,
    "DRS091": 99,
    "DRS092": 99,
    "DRS093": 99,
    "DRS094": 299,
    "DRS100": 99,
    "DRS114": 799,
    "DRS115": 399,
    "DRS120": 399,
    "DRS125": 599,
    "DRS126": 699,
    "DRS127": 299,
    "DRS130": 349,
    "DRS131": 399,
    "DRS133": 399,
    "DRS135": 399,
    "DRS136": 299,
    "DRS137": 299,
    "DRS142": 199,
    "DRS143": 149,
    "DRS145": 999,
    "DRS146": 499,
    "DRS147": 499,
    "DRS151": 299,
    "DRS160": 399,
    "DRS173": 399,
    "DRS174": 199,
    "DRS187": 149,
    "DRS188": 149,
    "DRS190": 399,
    "DRS191": 99,
    "DRS192": 299,
    "DRS193": 399,
}

PROFILE_PRICE_BY_CODE: dict[str, int] = {
    "DRSP001": 399,
    "DRSP002": 2499,
    "DRSP003": 1299,
    "DRSP004": 1499,
    "DRSP005": 1699,
    "DRSP006": 999,
    "DRSP007": 1299,
}


def to_slug(name: str) -> str:
    if not name or not name.strip():
        return "test"
    slug = re.sub(r"[^a-z0-9]+", "-", name.lower())
    return slug.strip("-")


def split_symptoms(raw: str) -> list[str]:
    if not raw:
        return []
    parts = re.split(r",\s*", raw.strip())
    return [p.strip() for p in parts if p.strip()]


def infer_sample_type(name: str) -> str:
    lower = name.lower()
    if "urine" in lower or "cue" in lower or "microalbuminuria" in lower:
        return "Urine"
    return "Blood"


def infer_fasting(name: str, code: str) -> bool:
    lower = name.lower()
    return "fasting" in lower or code in {"DRS091", "DRS120", "DRS061"}


def read_csv_rows(path: Path) -> csv.DictReader:
    """Skip the leading 'Table 1' row present in exported spreadsheets."""
    with path.open(newline="", encoding="utf-8") as f:
        lines = f.readlines()
    if lines and lines[0].strip().startswith("Table 1"):
        lines = lines[1:]
    return csv.DictReader(lines)


def read_test_list() -> list[dict]:
    rows: list[dict] = []
    reader = read_csv_rows(TEST_LIST_CSV)
    for row in reader:
            code = (row.get("Test Code") or "").strip()
            name = (row.get("Test Name") or "").strip()
            if not code or not name:
                continue
            rows.append(
                {
                    "code": code,
                    "name": name,
                    "nameTelugu": (row.get("Test Name - Telugu") or "").strip(),
                    "symptoms": split_symptoms(row.get("Symptoms") or ""),
                    "symptomsTelugu": split_symptoms(row.get("Symptoms In telugu") or ""),
                }
            )
    return rows


def read_categories(test_by_code: dict[str, dict]) -> list[dict]:
    categories: OrderedDict[str, dict] = OrderedDict()
    current_name = ""

    reader = read_csv_rows(CATEGORY_CSV)
    for row in reader:
            category_name = (row.get("Category") or "").strip()
            if category_name:
                current_name = category_name

            code = (row.get("Test Code") or "").strip()
            if not current_name or not code:
                continue

            slug = to_slug(current_name)
            if slug not in categories:
                categories[slug] = {
                    "slug": slug,
                    "name": current_name,
                    "testCodes": [],
                    "tests": [],
                }

            entry = categories[slug]
            if code not in entry["testCodes"]:
                entry["testCodes"].append(code)
                test = test_by_code.get(code)
                if test:
                    entry["tests"].append(
                        {
                            "code": code,
                            "slug": to_slug(test["name"]),
                            "name": test["name"],
                            "nameTelugu": test.get("nameTelugu", ""),
                            "symptoms": test.get("symptoms", []),
                        }
                    )

    result = []
    for cat in categories.values():
        cat["testCount"] = len(cat["testCodes"])
        result.append(cat)
    return result


def normalize_profile_test_name(name: str) -> str:
    cleaned = name.strip()
    aliases = {
        "Glucose - Fasting": "Glucose-Blood-Fasting",
        "Complete Blood Count (CBC)": "CBC",
        "Complete Urine Analysis (CUE)": "Complete Urine Analysis",
        "Iron Deficiency Profile-II": "Iron Defficiency Profile-II",
        "Iron Deficiency Profile-I": "Iron Defficiency Profile-I",
        "Kidney Function Test (KFT) - I": "Kidney Function Test (KFT)-Serum",
        "Kidney Function Test (KFT)": "Kidney Function Test (KFT)-Serum",
        "Lipid Profile": "Lipid Profile-Serum",
        "Liver Function Test (LFT)": "Liver Function Test (LFT)-Serum",
        "Thyroid Profile I": "Thyroid Profile-Total",
        "25 - Hydroxy Vitamin D - Serum": "25-Hydroxy Vitamin D-Serum",
        "Vitamin - B12 - Serum": "Vitamin-B12-Serum",
        "Rheumatoid Factor (RA Test) - Serum": "Rheumatoid Factor (RA Test)-Serum",
        "Dengue Ns1 Antigen / Antibody - Rapid": "Dengue NS1 RAPID",
        "WIDAL slide test for Salmonella typhi": "Widal Test (Slide Test)- Serum",
        "Malarial Falciparum and Vivax Antigen (PV/PF)": (
            "Malarial Falciparum and Vivax Antigen (Parasite V & F)"
        ),
        "Glucose-Urine -Fasting": "Glucose -Urine",
        "Glycosylated Hemoglobin (GHb/HbA1c)": (
            "Glycosylated Hemoglobin (GHb/HbA1c)-WB-EDTA"
        ),
        "Erythrocyte Sedimentation Rate (ESR)": (
            "Erythrocyte Sedimentation Rate (ESR)"
        ),
        "Thyroid Stimulating Hormone (TSH) - Serum": (
            "Thyroid Stimulating Hormone (TSH)-Serum"
        ),
    }
    return aliases.get(cleaned, cleaned)


def read_profiles(test_by_name: dict[str, dict], test_by_code: dict[str, dict]) -> list[dict]:
    profiles: list[dict] = []
    reader = read_csv_rows(PROFILES_CSV)
    for row in reader:
            code = (row.get("Test Code") or "").strip()
            name = (row.get("Profile Name") or "").strip()
            if not code or not name:
                continue

            raw_tests = (row.get("Test Names") or "").splitlines()
            raw_telugu = (row.get("Test Names - Telugu") or "").splitlines()
            included: list[dict] = []
            included_codes: list[str] = []

            for idx, raw_name in enumerate(raw_tests):
                normalized = normalize_profile_test_name(raw_name)
                test = test_by_name.get(normalized)
                telugu = raw_telugu[idx].strip() if idx < len(raw_telugu) else ""
                if test:
                    included.append(
                        {
                            "code": test["code"],
                            "slug": to_slug(test["name"]),
                            "name": test["name"],
                            "nameTelugu": telugu or test.get("nameTelugu", ""),
                        }
                    )
                    included_codes.append(test["code"])
                else:
                    included.append(
                        {
                            "code": None,
                            "slug": to_slug(normalized),
                            "name": normalized,
                            "nameTelugu": telugu,
                        }
                    )

            price = PROFILE_PRICE_BY_CODE.get(code, 999)
            profiles.append(
                {
                    "code": code,
                    "slug": to_slug(name),
                    "name": name,
                    "shortName": name.replace("DRS ", ""),
                    "testCount": len(included),
                    "priceCents": price * 100,
                    "currency": "INR",
                    "includedTestCodes": included_codes,
                    "includedTests": included,
                }
            )
    return profiles


def build_catalog_test(
    *,
    test_id: int,
    code: str,
    name: str,
    test_type: str,
    short_description: str,
    long_description: str,
    price_rupees: int,
    symptoms: list[str],
    categories: list[str],
    included_tests: list[str] | None = None,
    number_of_tests: int | None = None,
    sort_order: int,
) -> dict:
    sample_type = infer_sample_type(name)
    attrs = {
        "sampleType": sample_type,
        "fastingRequired": infer_fasting(name, code),
        "noAlcohol": False,
        "demographics": [],
        "testCategories": categories,
        "testAudience": [],
        "testType": test_type,
        "symptoms": symptoms,
        "numberOfTests": number_of_tests,
        "internalCode": code,
        "externalCode": code,
        "alternativeNames": "",
        "includedTests": included_tests or [],
    }

    return {
        "id": str(test_id),
        "slug": to_slug(name),
        "name": name,
        "shortDescription": short_description,
        "longDescription": long_description,
        "testType": test_type,
        "priceCents": price_rupees * 100,
        "currency": "INR",
        "parameterCount": 1,
        "imageUrl": DEFAULT_IMAGE,
        "thumbnailUrl": DEFAULT_IMAGE,
        "galleryJson": [],
        "attributesJson": attrs,
        "badge": None,
        "isFeatured": False,
        "featuredOrder": sort_order,
        "sortOrder": sort_order,
        "active": True,
    }


def main() -> None:
    tests = read_test_list()
    test_by_code = {t["code"]: t for t in tests}
    test_by_name = {t["name"]: t for t in tests}
    categories = read_categories(test_by_code)
    profiles = read_profiles(test_by_name, test_by_code)

    code_to_categories: dict[str, list[str]] = {}
    for cat in categories:
        for code in cat["testCodes"]:
            code_to_categories.setdefault(code, []).append(cat["name"])

    catalog_tests: list[dict] = []
    sort_order = 0

    for test in tests:
        code = test["code"]
        price = PRICE_BY_CODE.get(code, 199)
        symptoms = test["symptoms"]
        long_desc = "\n".join(symptoms) if symptoms else test["name"]
        catalog_tests.append(
            build_catalog_test(
                test_id=sort_order + 1,
                code=code,
                name=test["name"],
                test_type="Test",
                short_description=symptoms[0] if symptoms else test["name"],
                long_description=long_desc,
                price_rupees=price,
                symptoms=symptoms,
                categories=code_to_categories.get(code, []),
                sort_order=sort_order,
            )
        )
        sort_order += 1

    profile_start_id = sort_order + 1
    for idx, profile in enumerate(profiles):
        included_names = [t["name"] for t in profile["includedTests"]]
        price_rupees = profile["priceCents"] // 100
        catalog_tests.append(
            build_catalog_test(
                test_id=profile_start_id + idx,
                code=profile["code"],
                name=profile["name"],
                test_type="Profile",
                short_description=f"{profile['testCount']} tests included",
                long_description="\n".join(included_names),
                price_rupees=price_rupees,
                symptoms=[],
                categories=["Checkup"],
                included_tests=included_names,
                number_of_tests=profile["testCount"],
                sort_order=sort_order,
            )
        )
        sort_order += 1

    catalog = {
        "tests": catalog_tests,
        "promotions": [],
        "featuredCollections": [],
    }

    OUT_DIR.mkdir(parents=True, exist_ok=True)
    (OUT_DIR / "catalog.json").write_text(
        json.dumps(catalog, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    (OUT_DIR / "categories.json").write_text(
        json.dumps({"categories": categories}, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    (OUT_DIR / "profiles.json").write_text(
        json.dumps({"profiles": profiles}, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )

    print(f"Wrote {len(catalog_tests)} catalog tests to {OUT_DIR / 'catalog.json'}")
    print(f"Wrote {len(categories)} categories to {OUT_DIR / 'categories.json'}")
    print(f"Wrote {len(profiles)} profiles to {OUT_DIR / 'profiles.json'}")


if __name__ == "__main__":
    main()
