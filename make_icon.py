# Dessine l'icone de l'appli et cree le catalogue d'images Xcode
import json, math, os, random
from PIL import Image, ImageDraw, ImageFont

A = "Sources/Assets.xcassets"
os.makedirs(A + "/AppIcon.appiconset", exist_ok=True)
os.makedirs(A + "/LaunchColor.colorset", exist_ok=True)
json.dump({"info": {"author": "xcode", "version": 1}}, open(A + "/Contents.json", "w"))
json.dump({"images": [{"filename": "icon.png", "idiom": "universal", "platform": "ios", "size": "1024x1024"}],
           "info": {"author": "xcode", "version": 1}}, open(A + "/AppIcon.appiconset/Contents.json", "w"))
json.dump({"colors": [{"idiom": "universal", "color": {"color-space": "srgb",
           "components": {"red": "1.000", "green": "0.240", "blue": "0.500", "alpha": "1.000"}}}],
           "info": {"author": "xcode", "version": 1}}, open(A + "/LaunchColor.colorset/Contents.json", "w"))

S = 1024
img = Image.new("RGB", (S, S))
d = ImageDraw.Draw(img)
for y in range(S):
    t = y / S
    d.line([(0, y), (S, y)], fill=(255, int(61 + 109 * t), int(127 * (1 - t))))
random.seed(4)
for _ in range(40):
    x, y, r, a = random.randint(0, S), random.randint(0, S), S * 0.018, random.random() * math.pi
    pts = [(x + r * math.cos(a + k * math.pi / 2) * (1.6 if k % 2 else .6),
            y + r * math.sin(a + k * math.pi / 2) * (1.6 if k % 2 else .6)) for k in range(4)]
    d.polygon(pts, fill=random.choice([(255, 255, 255), (64, 224, 208), (124, 77, 255), (255, 235, 59)]))
font = None
for f in ["/System/Library/Fonts/Supplemental/Arial Black.ttf",
          "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
          "/usr/share/fonts/truetype/google-fonts/Poppins-Bold.ttf"]:
    if os.path.exists(f):
        font = ImageFont.truetype(f, int(S * 0.22)); break
b = d.textbbox((0, 0), "BINGO", font=font)
x, y = (S - (b[2] - b[0])) / 2 - b[0], (S - (b[3] - b[1])) / 2 - b[1]
d.text((x + 12, y + 15), "BINGO", font=font, fill=(120, 20, 60))
d.text((x, y), "BINGO", font=font, fill=(255, 255, 255))
img.save(A + "/AppIcon.appiconset/icon.png")
print("icone ok")
