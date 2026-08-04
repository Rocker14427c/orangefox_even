# OrangeFox Recovery device tree — Realme "even"

Unified tree for the MediaTek **MT6768** family:

| Device | Model | `ro.boot.prjname` |
|---|---|---|
| Realme C25 | RMX3191 | 20761 |
| Realme C25 | RMX3193 | 20762 |
| Realme C25s | RMX3195 | 2167A / 2167C |
| Realme C25s | RMX3197 | 2167D |
| **Realme Narzo 50A** | **RMX3430** | **216AF** |

Base: Android 12.1 minimal TWRP tree + OrangeFox R12 sources (`fox_12.1`, stable) — or `fox_14.1` (experimental).
Decryption: prebuilt unified kernel/dtbo/dtb + Trustonic TEE (Kinibi) stack for FBE/metadata decrypt.

---

## 1. One-click cloud build (GitHub Actions) — recommended

1. Push/fork this repo to your GitHub account (public or private).
2. Go to **Actions → OrangeFox Recovery Build (even) → Run workflow**.
3. Keep defaults (`FOX_BRANCH = 12.1`, `DEVICE_NAME = even`, `BUILD_TARGET = recovery`) → **Run**.
4. When it finishes (~1.5–3 h), grab `recovery.img` + `OrangeFox-*.zip` from **Releases** (also attached as workflow artifacts, with the stock-TWRP-style `recovery.img`).

No PC, no local setup needed — GitHub's free runner does everything using the
**official OrangeFox sync script** (`gitlab.com/OrangeFox/sync`), so the tree is always
fetched fresh and patched the way OrangeFox devs intend.

## 2. Manual build (Linux PC)

```bash
# 1. Sync the OrangeFox-patched minimal manifest (official script)
git clone https://gitlab.com/OrangeFox/sync.git ofsync
bash ofsync/orangefox_sync.sh --branch 12.1 --path "$HOME/fox_src"

# 2. Add this device tree
cd "$HOME/fox_src"
git clone <this-repo-url> -b main device/realme/even

# 3. Build
source build/envsetup.sh
export ALLOW_MISSING_DEPENDENCIES=true
lunch twrp_even-eng
mka adbd recoveryimage -j$(nproc --all)

# Output: out/target/product/even/recovery.img  +  OrangeFox-<ver>-Unofficial-even.zip
```

Requirements: Ubuntu 20.04/22.04, ~25 GB free disk, 8 GB+ RAM, OpenJDK 8 (fox_12.1) or 17 (fox_14.1).

## 3. Flashing on the Realme Narzo 50A (RMX3430)

> ⚠️ Unlocking the bootloader **wipes all data**. Backup first. You do this at your own risk.

```bash
adb reboot bootloader                      # (bootloader must be unlocked first)
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img   # from your current stock ROM
fastboot flash recovery recovery.img
fastboot reboot recovery
```

Notes
- This phone has a **real recovery partition** (128 MB, non-A/B) — flash to `recovery`, **not** `boot`.
- OrangeFox is built with magiskboot and will offer to patch/keep vbmeta (`OF_PATCH_VBMETA_FLAG`) when you first boot it or flash the `OrangeFox-*.zip` **from an existing custom recovery** — that's the easiest install path if you already have TWRP.
- FBE `/data` decryption relies on the RUI3/RUI4-era TEE blobs in this tree; it works best when your stock firmware is current Realme UI. If `/data` shows 0 MB/encrypted names, use **Format Data** (this wipes encryption) once.
- To return to stock: flash the stock `recovery.img` + stock `vbmeta.img`, or use SP Flash Tool with the stock OFP.

## 4. Device specifications (build-relevant)

- SoC: MT6768 platform (Helio G70/G80/G85) — `TARGET_BOARD_PLATFORM := mt6768`, board `RM6768`
- Kernel: prebuilt unified `Image.gz` + `dtbo` + `dtb` (header v2, base 0x40078000, 2048 page)
- Display: 720×1600 (portrait_hdpi) — notch handled (`OF_HIDE_NOTCH=1`, `OF_SCREEN_H=1600`)
- Partitions: dynamic `super` (system/system_ext/product/vendor/vendor_dlkm/odm/odm_dlkm, erofs/ext4), F2FS userdata, `/metadata` (md_udc)
- Crypto: FBE v2 inlinecrypt (aes-256-xts/cts), metadata encryption, Trustonic TEE (`mcRegistry`)

## Credits
- Badmaneers — base TWRP/unified device tree & kernels (twrp_realme_even, saturn/zenium)
- cumaRull — original android-13 vendor decryption stack
- The OrangeFox Recovery Project & TeamWin
