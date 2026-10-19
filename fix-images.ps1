# fix-images.ps1 - 壊れた写真を全部修正するスクリプト
$dir = $PSScriptRoot
$cache = "$dir\img_cache"
$base = "http://9735d088cad1dee7.main.jp/wp-content/uploads"
$utf8 = New-Object System.Text.UTF8Encoding $false

if (-not (Test-Path $cache)) { New-Item -ItemType Directory -Force $cache | Out-Null }
Write-Host "=== 写真ダウンロード開始 ===" -ForegroundColor Cyan

function dl($year, $month, $file, $save) {
    $out = "$cache\$save"
    if (Test-Path $out) { Write-Host "SKIP: $save"; return }
    $encoded = [System.Uri]::EscapeDataString($file)
    $url = "$base/$year/$month/$encoded"
    try {
        Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing -TimeoutSec 30
        Write-Host "OK: $save" -ForegroundColor Green
    } catch {
        Write-Host "NG: $save" -ForegroundColor Red
    }
}

# plan-gyosei.html
dl "2026" "10" "スライド1-1.jpg" "slide1-1.jpg"
dl "2026" "10" "スライド4-1.jpg" "slide4-1.jpg"
dl "2026" "10" "スライド5-1.jpg" "slide5-1.jpg"

# manufacturing-logistics-bcp.html
dl "2026" "10" "スライド2-1.jpg" "slide2-1.jpg"
dl "2026" "10" "スライド3.jpg" "slide3.jpg"

# commerce-service-bcp.html
dl "2026" "10" "ホームページ素材-ショッピングモール等写真.jpg" "shopping-mall.jpg"
dl "2026" "10" "ホームページ素材-ショッピングモール等写真-1.jpg" "shopping-mall-1.jpg"
dl "2025" "07" "★模擬訓練-27-HP-scaled.jpg" "mogi27-hp-scaled.jpg"

# edu-school-bcp.html
dl "2026" "10" "ＨＰ-模擬訓練-4-scaled.jpg" "mogi4-scaled.jpg"
dl "2026" "10" "★模擬訓練-3-scaled.jpg" "mogi3-2026-scaled.jpg"
dl "2026" "10" "ＨＰ-★模擬訓練-scaled.jpg" "mogi-hp-star-scaled.jpg"

# plan-kigyou.html
dl "2026" "10" "IMG_5712.jpg" "IMG_5712.jpg"
dl "2025" "08" "写真③.jpeg" "photo3.jpeg"

# index.html
dl "2026" "10" "IMG_20260915_131147-scaled.jpg" "IMG_20260915_131147-scaled.jpg"
dl "2024" "11" "ＨＰ代表→先生⑤-scaled.jpg" "daihyo-sensei5-scaled.jpg"
dl "2025" "07" "★模擬訓練-scaled.jpg" "mogi-2025-scaled.jpg"
dl "2025" "07" "ＨＰ　講話-5-scaled.jpg" "kouwa5-scaled.jpg"
dl "2021" "02" "厚生労働省HPロゴ２ーサイズ中ーアップ.jpg" "mhlw-logo.jpg"

# ccp-about.html
dl "2026" "10" "確認し合う-scaled.jpg" "kakunin-scaled.jpg"

# impression files
dl "2022" "07" "ＨＰ用　砥部社協　アンケート記載済み_page-0001-724x1024.jpg" "tobe-anketo.jpg"
dl "2022" "07" "ＨP用　危機管理指導終了アンケート　のびのびハウス_page-0001-724x1024.jpg" "nobinobi-anketo.jpg"
dl "2020" "09" "HP2114-1024x640.jpg" "HP2114-1024x640.jpg"
dl "2020" "02" "IMG_20191103_153944.jpg" "IMG_20191103_153944.jpg"

# endseminar-osaka-school.html
dl "2025" "08" "★模擬訓練-3-768x1024.jpg" "mogi3-768x1024.jpg"

Write-Host ""
Write-Host "=== HTMLファイル修正開始 ===" -ForegroundColor Cyan

function fix($htmlFile, $mappings) {
    $path = "$dir\$htmlFile"
    $content = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)
    $changed = $false
    foreach ($m in $mappings) {
        if ($content.Contains($m.old)) {
            $content = $content.Replace($m.old, $m.new)
            $changed = $true
        }
    }
    if ($changed) {
        [System.IO.File]::WriteAllText($path, $content, $utf8)
        Write-Host "OK: $htmlFile" -ForegroundColor Green
    }
}

fix "plan-gyosei.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/スライド1-1.jpg"; new="img_cache/slide1-1.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/スライド4-1.jpg"; new="img_cache/slide4-1.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/スライド5-1.jpg"; new="img_cache/slide5-1.jpg"}
)

fix "manufacturing-logistics-bcp.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/スライド2-1.jpg"; new="img_cache/slide2-1.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/スライド3.jpg"; new="img_cache/slide3.jpg"}
)

fix "commerce-service-bcp.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/ホームページ素材-ショッピングモール等写真.jpg"; new="img_cache/shopping-mall.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/ホームページ素材-ショッピングモール等写真-1.jpg"; new="img_cache/shopping-mall-1.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2025/07/%E2%98%85%E6%A8%A1%E6%93%AC%E8%A8%93%E7%B7%B4-27-HP-scaled.jpg"; new="img_cache/mogi27-hp-scaled.jpg"}
)

fix "edu-school-bcp.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/ＨＰ-模擬訓練-4-scaled.jpg"; new="img_cache/mogi4-scaled.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/%EF%BC%A8%EF%BC%B0-%E6%A8%A1%E6%93%AC%E8%A8%93%E7%B7%B4-4-scaled.jpg"; new="img_cache/mogi4-scaled.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/%E2%98%85%E6%A8%A1%E6%93%AC%E8%A8%93%E7%B7%B4-3-scaled.jpg"; new="img_cache/mogi3-2026-scaled.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/%EF%BC%A8%EF%BC%B0-%E2%98%85%E6%A8%A1%E6%93%AC%E8%A8%93%E7%B7%B4-scaled.jpg"; new="img_cache/mogi-hp-star-scaled.jpg"},
    @{old="var base = 'https://jdrs21.jp/wp-content/uploads/2026/10/';"; new="var base = 'img_cache/';"}
)

fix "plan-kigyou.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/IMG_5712.jpg"; new="img_cache/IMG_5712.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2025/08/写真③.jpeg"; new="img_cache/photo3.jpeg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2025/08/%E5%86%99%E7%9C%9F%E2%91%A2.jpeg"; new="img_cache/photo3.jpeg"}
)

fix "index.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/IMG_20260915_131147-scaled.jpg"; new="img_cache/IMG_20260915_131147-scaled.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2024/11/ＨＰ代表→先生⑤-scaled.jpg"; new="img_cache/daihyo-sensei5-scaled.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2025/07/ＨＰ　講話-5-scaled.jpg"; new="img_cache/kouwa5-scaled.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2025/07/★模擬訓練-scaled.jpg"; new="img_cache/mogi-2025-scaled.jpg"},
    @{old="https://jdrs21.jp/wp-content/uploads/2021/02/厚生労働省HPロゴ２ーサイズ中ーアップ.jpg"; new="img_cache/mhlw-logo.jpg"}
)

fix "ccp-about.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2026/10/%E7%A2%BA%E8%AA%8D%E3%81%97%E5%90%88%E3%81%86-scaled.jpg"; new="img_cache/kakunin-scaled.jpg"}
)

fix "impression-bcp-kouen.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2022/07/ＨＰ用　砥部社協　アンケート記載済み_page-0001-724x1024.jpg"; new="img_cache/tobe-anketo.jpg"}
)

fix "impression-kiki-kanri.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2022/07/ＨP用　危機管理指導終了アンケート　のびのびハウス_page-0001-724x1024.jpg"; new="img_cache/nobinobi-anketo.jpg"}
)

fix "impression-corona.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2020/09/HP2114-1024x640.jpg"; new="img_cache/HP2114-1024x640.jpg"}
)

fix "childcare-bcp.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2020/02/IMG_20191103_153944.jpg"; new="img_cache/IMG_20191103_153944.jpg"}
)

fix "endseminar-osaka-school.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2025/08/★模擬訓練-3-768x1024.jpg"; new="img_cache/mogi3-768x1024.jpg"}
)

fix "jdrs-ko-do-v3.html" @(
    @{old="https://jdrs21.jp/wp-content/uploads/2021/02/厚生労働省HPロゴ２ーサイズ中ーアップ.jpg"; new="img_cache/mhlw-logo.jpg"}
)

Write-Host ""
Write-Host "=== 完了！次のコマンドを実行してください ===" -ForegroundColor Yellow
Write-Host "git add -A"
Write-Host "git commit -m `"fix all images`""
Write-Host "git push"
