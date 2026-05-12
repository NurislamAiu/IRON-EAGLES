import re

output_file = "/Users/timurzhangulov/StudioProjects/IRON-EAGLES/lib/core/utils/mock_artifacts.dart"

with open(output_file, "r") as f:
    content = f.read()

# Replace any occurrence of 'assets/images/museum_bg_X.jpeg' back to ''
content = re.sub(r"imageUrl: 'assets/images/museum_bg_\d+\.jpeg',", "imageUrl: '',", content)

with open(output_file, "w") as f:
    f.write(content)

print("Done resetting fake background images to empty strings.")
