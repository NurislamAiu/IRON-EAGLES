import re

output_file = "/Users/timurzhangulov/StudioProjects/IRON-EAGLES/lib/core/utils/mock_artifacts.dart"

with open(output_file, "r") as f:
    content = f.read()

# We will find all imageUrl: '' and replace them with imageUrl: 'assets/images/museum_bg_X.jpeg'
# But some are imageUrl: 'http...', we will not touch them.

lines = content.split('\n')
img_index = 0
for i, line in enumerate(lines):
    if "imageUrl: ''," in line:
        lines[i] = line.replace("imageUrl: '',", f"imageUrl: 'assets/images/museum_bg_{img_index % 29}.jpeg',")
        img_index += 1

with open(output_file, "w") as f:
    f.write('\n'.join(lines))

print("Done replacing image URLs.")
