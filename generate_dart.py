import json
import os

input_file = "/Users/timurzhangulov/StudioProjects/IRON-EAGLES/artifacts_temp.json"
output_file = "/Users/timurzhangulov/StudioProjects/IRON-EAGLES/lib/core/utils/mock_artifacts.dart"

with open(input_file, "r") as f:
    data = json.load(f)

dart_code = """import 'package:ArcheoAI/features/artifacts/domain/artifact_model.dart';
import 'package:ArcheoAI/core/utils/generate_random_id.dart';

final List<Artifact> mockArtifacts = [
"""

for i, item in enumerate(data):
    id_val = item.get("id", "")
    title_val = item.get("title", "").replace("'", "\\'")
    desc_val = item.get("description", "").replace("'", "\\'")
    region_val = item.get("region", "").replace("'", "\\'")
    image_url_val = item.get("image_url", "").replace("'", "\\'")
    source_val = item.get("source", "").replace("'", "\\'")
    culture_val = item.get("culture", "").replace("'", "\\'")
    period_val = item.get("period", "").replace("'", "\\'")
    material_val = item.get("material", "").replace("'", "\\'")

    if not image_url_val.startswith('http'):
        # Pick one of the available museum backgrounds by cycling through 0-28
        img_index = i % 29
        image_url_val = f'assets/images/museum_bg_{img_index}.jpeg'

    dart_code += f"""  Artifact(
    id: '{id_val}',
    title: '{title_val}',
    description: '{desc_val}',
    foundLocation: '{region_val}',
    imageUrl: '{image_url_val}',
    modelUrl: '',
    qrCodeUrl: '',
    addedBy: 'system-seed',
    createdAt: DateTime.now(),
    originName: '{source_val}',
    category: '{culture_val}',
    period: '{period_val}',
    material: '{material_val}',
  ),
"""

dart_code += "];\n"

with open(output_file, "w") as f:
    f.write(dart_code)

print(f"Generated {len(data)} artifacts into {output_file}")
