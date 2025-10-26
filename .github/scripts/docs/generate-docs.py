import os
import re
import argparse

START_MARKER = "--[[ doc.lua begin ]]"
END_MARKER = "--[[ doc.lua end ]]"


def extract_doc_blocks(file_path):
    with open(file_path, "r", encoding="utf-8") as f:
        content = f.read()

    blocks = []
    pattern = re.compile(
        re.escape(START_MARKER) + r"(.*?)" + re.escape(END_MARKER),
        re.DOTALL
    )
    for match in pattern.findall(content):
        blocks.append(match.strip())
    return blocks


def parse_addon_file(addon_file):
    lua_files = []
    addon_dir = os.path.dirname(os.path.abspath(addon_file))

    with open(addon_file, "r", encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith(("#", ";", "##")):
                continue
            if line.endswith(".lua"):
                full_path = os.path.join(addon_dir, line)
                lua_files.append((line, full_path))
    return lua_files


def generate_main_file(lua_files, addon_root, output_file):
    all_blocks = []

    for rel_path, full_path in lua_files:
        if os.path.isfile(full_path):
            blocks = extract_doc_blocks(full_path)
            if blocks:
                # rel_display = os.path.relpath(full_path, addon_root)
                all_blocks.extend(blocks)
                all_blocks.append("")  # for spacing
        else:
            print(f"⚠️ Warning: File not found: {rel_path}")

    os.makedirs(os.path.dirname(output_file), exist_ok=True)
    with open(output_file, "w", encoding="utf-8") as f:
        f.write("\n\n\n".join(all_blocks))

    print(f"✅ Documentation generated: {output_file}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("addon_file", help="Path to the .addon file")
    parser.add_argument("output_dir", help="Directory to save main.lua")
    args = parser.parse_args()

    addon_file = os.path.abspath(args.addon_file)
    output_file = os.path.join(os.path.abspath(args.output_dir), "docs.lua")

    lua_files = parse_addon_file(addon_file)
    generate_main_file(lua_files, os.path.dirname(addon_file), output_file)


if __name__ == "__main__":
    main()
