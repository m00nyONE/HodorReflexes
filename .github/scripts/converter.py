import os
import re
import shutil

INPUT_DIR = "users"
OUTPUT_DIR = "output"
OUTPUT_NAMES_DIR = os.path.join(OUTPUT_DIR, "LibCustomNames")
OUTPUT_ICONS_DIR = os.path.join(OUTPUT_DIR, "LibCustomIcons")

# Regexe
pattern_normal = re.compile(r'u\["(?P<user>@[^"]+)"]\s*=\s*\{(?P<parts>[^}]+)}')
pattern_alias = re.compile(r'u\["(?P<user>@[^"]+)"]\s*=\s*u\["(?P<target>@[^"]+)"]')
pattern_anim = re.compile(r'a\["(?P<user>@[^"]+)"]\s*=\s*\{(?P<parts>[^}]+)}')
pattern_anim_alias = re.compile(r'a\["(?P<user>@[^"]+)"]\s*=\s*a\["(?P<target>@[^"]+)"]')

header = """local lib_name = "LibCustomNames"
local lib = _G[lib_name]
local n = lib.GetNamesTable()

"""

icon_header = """local lib_name = "LibCustomIcons"
local lib = _G[lib_name]
local s = lib.GetStaticTable()
local a = lib.GetAnimatedTable()

"""


def replace_path(path):
    return path.replace("HodorReflexes/users/", "LibCustomIcons/icons/")


def parse_name_line(line, line_number, filename):
    line = line.strip()

    if m := pattern_alias.match(line):
        return "alias", m.group("user"), m.group("target")

    if m := pattern_normal.match(line):
        user = m.group("user")
        parts = [p.strip().strip('"') for p in m.group("parts").split(",")]
        if len(parts) < 2:
            print(f"⚠️ Incomplete name data in {filename} (Line {line_number}): {line}")
            return None
        name, uncolored = parts[0], parts[1]
        texture = replace_path(parts[2]) if len(parts) >= 3 else None
        return "normal", user, name, uncolored, texture

    return None


def parse_anim_line(line, line_number, filename):
    if m := pattern_anim.match(line.strip()):
        user = m.group("user")
        parts = [p.strip().strip('"') for p in m.group("parts").split(",")]
        parts[0] = replace_path(parts[0])
        return user, parts
    return None


def convert_file(input_path, rel_path, global_names, global_icons):
    entries = {}
    aliases = {}
    icon_entries = {}

    name_order = []
    alias_order = []
    icon_order = []

    # Für Names: flach (nur Dateiname)
    output_name_path = os.path.join(OUTPUT_NAMES_DIR, os.path.basename(rel_path))
    # Icons-Datei ebenfalls flach:
    output_icon_path = os.path.join(OUTPUT_ICONS_DIR, os.path.basename(rel_path))

    os.makedirs(os.path.dirname(output_icon_path), exist_ok=True)
    os.makedirs(OUTPUT_NAMES_DIR, exist_ok=True)

    with open(input_path, encoding="utf-8") as infile:
        for i, line in enumerate(infile, start=1):
            line = line.strip()
            if line.startswith("u["):
                result = parse_name_line(line, i, rel_path)
                if not result:
                    print(f"⚠️ Invalid line in {rel_path} (Line {i}): {line}")
                    continue

                if result[0] == "alias":
                    user, target = result[1], result[2]
                    alias_line = f'n["{user}"] = n["{target}"]'
                    if user not in aliases:
                        aliases[user] = alias_line
                        alias_order.append(user)
                        if user not in global_names["aliases"]:
                            global_names["aliases"][user] = alias_line
                            global_names["alias_order"].append(user)
                else:
                    _, user, name, uncolored, texture = result
                    entry_line = f'n["{user}"] = {{"{name}", "{uncolored}"}}'
                    if user not in entries:
                        entries[user] = entry_line
                        name_order.append(user)
                        if user not in global_names["entries"]:
                            global_names["entries"][user] = entry_line
                            global_names["entry_order"].append(user)
                    if texture and user not in global_icons["static"]:
                        icon_line = f's["{user}"] = "{texture}"'
                        global_icons["static"][user] = icon_line
                        global_icons["static_order"].append(user)
                        icon_entries[user] = True
                        icon_order.append(user)

            elif line.startswith("a["):
                if m := pattern_anim_alias.match(line):
                    user = m.group("user")
                    target = m.group("target")
                    alias_line = f'a["{user}"] = a["{target}"]'
                    if user not in global_icons["animated_aliases"]:
                        global_icons["animated_aliases"][user] = alias_line
                        global_icons["animated_alias_order"].append(user)
                        icon_entries[user] = True
                        icon_order.append(user)
                else:
                    result = parse_anim_line(line, i, rel_path)
                    if not result:
                        continue
                    user, parts = result
                    icon_line = f'a["{user}"] = {{"{parts[0]}"' + ''.join([f", {p}" for p in parts[1:]]) + "}"
                    if user not in global_icons["animated"]:
                        global_icons["animated"][user] = icon_line
                        global_icons["animated_order"].append(user)
                        icon_entries[user] = True
                        icon_order.append(user)

    # Namen-Datei schreiben (flach)
    with open(output_name_path, "w", encoding="utf-8") as outname:
        outname.write(header)
        for user in name_order:
            outname.write(entries[user] + "\n")
        for user in alias_order:
            outname.write(aliases[user] + "\n")

    # Icon-Datei schreiben (mit Unterordnerstruktur)
    with open(output_icon_path, "w", encoding="utf-8") as outicon:
        outicon.write(icon_header)
        for user in global_icons["static_order"]:
            if user in icon_entries:
                outicon.write(global_icons["static"][user] + "\n")
        for user in global_icons["animated_order"]:
            if user in icon_entries:
                outicon.write(global_icons["animated"][user] + "\n")
        for user in global_icons["animated_alias_order"]:
            if user in icon_entries:
                outicon.write(global_icons["animated_aliases"][user] + "\n")

    print(f"✅ {rel_path}: {len(entries)} Names, {len(aliases)} Aliases, {len(icon_entries)} Icons")


def write_combined_file(path, header_text, entries, order):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        f.write(header_text)
        for user in order:
            f.write(entries[user] + "\n")


def copy_dds_files():
    for root, _, files in os.walk(INPUT_DIR):
        for file in files:
            if file.lower().endswith(".dds"):
                src_path = os.path.join(root, file)
                rel_path = os.path.relpath(src_path, INPUT_DIR)
                dest_path = os.path.join(OUTPUT_ICONS_DIR, rel_path)
                os.makedirs(os.path.dirname(dest_path), exist_ok=True)
                shutil.copy2(src_path, dest_path)
                print(f"📋 copied: {rel_path}")


def main():
    global_names = {
        "entries": {}, "aliases": {},
        "entry_order": [], "alias_order": []
    }
    global_icons = {
        "static": {}, "animated": {}, "animated_aliases": {},
        "static_order": [], "animated_order": [], "animated_alias_order": []
    }

    for root, _, files in os.walk(INPUT_DIR):
        for file in files:
            if not file.lower().endswith(".lua"):
                continue
            full_path = os.path.join(root, file)
            rel_path = os.path.relpath(full_path, INPUT_DIR)
            convert_file(full_path, rel_path, global_names, global_icons)

    # all.lua für Namen (flach)
    write_combined_file(
        os.path.join(OUTPUT_NAMES_DIR, "all.lua"),
        header,
        {**global_names["entries"], **global_names["aliases"]},
        global_names["entry_order"] + global_names["alias_order"]
    )

    # all.lua für Icons (mit Struktur)
    all_icon_path = os.path.join(OUTPUT_ICONS_DIR, "all.lua")
    with open(all_icon_path, "w", encoding="utf-8") as f:
        f.write(icon_header)
        for user in global_icons["static_order"]:
            f.write(global_icons["static"][user] + "\n")
        for user in global_icons["animated_order"]:
            f.write(global_icons["animated"][user] + "\n")
        for user in global_icons["animated_alias_order"]:
            f.write(global_icons["animated_aliases"][user] + "\n")

    print("📦 all.lua File created (names + icons)")

    # DDS Dateien kopieren
    copy_dds_files()


if __name__ == "__main__":
    main()
