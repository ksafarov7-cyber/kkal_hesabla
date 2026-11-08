# Kalori AI

iPhone üçün **PWA**: yeməyin şəklini çəkirsiniz, süni intellekt yeməyi tanıyır, içindəkiləri qram-qram ayırır və kalori / zülal / karbohidrat / yağ dəyərini hesablayır. Nəticəni əl ilə düzəldə, ərzaq əlavə edə və AI-yə yenidən hesablada bilirsiniz. Hər gün üçün ayrıca gündəlik tutulur.

Backend yoxdur — tətbiq statik fayllardan ibarətdir və birbaşa Google Gemini-yə müraciət edir. API açarı `config.js` faylındadır, interfeysdə göstərilmir.

![Tətbiqin görünüşü](preview.png)

## Nə edir

- **Şəkildən analiz** — kamera və ya qalereya. Şəkil avtomatik 1200px-ə kiçilir.
- **AI cavabı** — yeməyin adı, növü, təsviri, tərkibi (hər məhsulun qramı, kalorisi, zülalı, karbohidratı, yağı), ümumi göstəricilər, AI inam faizi.
- **Tərkibi əl ilə düzəlt** — hər məhsulun qramını dəyiş, lazımsızunu sil. `＋ Ərzaq əlavə et` ilə 100-dən çox məhsulluq **axtarışlı siyahı**dan seç və ya siyahıda olmayanı özün yaz (100 q üçün kalori və makrolar).
- **AI ilə yenidən hesabla** — tərkib dəyişdikdən sonra düyməni bas; AI bütün qramları nəzərə alıb kalori və makroları yenidən hesablayır.
- **Gündəlik** — gün seçimi: `‹ ›` düymələri, son 7 günün qrafiki (sütuna toxun) və “Günlər” siyahısı. Seçilmiş günün kalorisi, makroları və yeməkləri görünür; yeməyə toxunanda tərkibi açılır.
- **Tema** — Avtomatik (telefonun rejiminə görə), Açıq, Tünd.
- **Ayarlar** — gündəlik hədəf, AI modeli, mövcud modellərin siyahısı.
- **Offline app shell** — service worker interfeysi keşləyir; internet yalnız AI sorğusu üçün lazımdır.
- **iPhone detalları** — `standalone` rejimi, safe-area, apple-touch-icon, “Ekrana əlavə et” ipucu.

## Sürətli başlanğıc (kompüterdə)

1. `baslat.cmd` faylını iki dəfə açın (və ya bu qovluqda `python -m http.server 8123`).
2. Brauzerdə `http://localhost:8123` açın.

`localhost` təhlükəsiz kontekst sayıldığı üçün kamera və service worker burada işləyir. `index.html`-i birbaşa (`file://`) açmayın — PWA işləməyəcək.

## iPhone-a quraşdırma

PWA-nın telefonda quraşdırılması və kamerasının işləməsi üçün **HTTPS** lazımdır. Ən asan yol:

1. [Netlify Drop](https://app.netlify.com/drop) səhifəsinə **`kalori-ai.zip`** faylını (və ya `kalori-ai` qovluğunu) sürüşdürün. Dərhal `https://...netlify.app` linki alırsınız (hesab lazım deyil).
   Alternativ: GitHub Pages, Vercel, Cloudflare Pages — hamısı pulsuzdur.
2. Linki **iPhone Safari**-də açın.
3. **Paylaş → “Ekrana əlavə et”**.
4. Tətbiqi açın — AI hazırdır, açar daxil etmək lazım deyil.

> Faylları dəyişdikdən sonra yenidən yükləyin. Service worker `v1.1.0` keşi avtomatik yeniləyir; ilk açılışda səhifəni iki dəfə yeniləmək lazım ola bilər.

## AI konfiqurasiyası (açar kodda)

Açar **`config.js`** faylındadır:

```js
window.KALORI_CONFIG = {
  geminiApiKey: 'AQ....',
};
```

- İnterfeysdə API açarı sahəsi, provayder seçimi və ya Base URL yoxdur — istifadəçi açarı görmür.
- Açarı dəyişmək üçün `config.js`-i redaktə edib yenidən deploy edin.
- Standart model: **`gemini-3.6-flash`** (~5–10 saniyə). Ayarlarda **“Mövcud modelləri gətir”** düyməsi açarınıza uyğun modelləri siyahıya salır.
- Köhnə `gemini-2.5-flash` yeni istifadəçilər üçün bağlıdır (404). Tətbiq bu halda avtomatik `gemini-3.6-flash → gemini-3.7-flash → gemini-3.5-flash-lite` sırası ilə yoxlayır.
- Yeni açar lazım olsa: [aistudio.google.com/app/apikey](https://aistudio.google.com/app/apikey) → **Create API key**.

> **Vacib:** statik saytda açar mənbə kodunda görünür. Şəxsi istifadə üçün bu normaldır, amma linki ictimai paylaşsanız, açarı istənilən adam çıxara bilər. Ciddi paylaşım üçün backend proxy (açar serverdə) lazımdır — bu, növbəti addımdır.

## Tema

Ayarlar → **Görünüş**:

- **Avtomatik** (default) — telefon ağ rejimdədirsə ağ, qara rejimdədirsə qara.
- **Açıq** / **Tünd** — əl ilə seçim. Seçim dərhal tətbiq olunur və yadda saxlanılır.

## Gündəlik: günə baxmaq

1. **Gündəlik** bölməsinə keçin.
2. `‹` / `›` ilə günü dəyişin, 7 günlük qrafikdə sütuna toxunun və ya aşağıdakı **Günlər** siyahısından gün seçin.
3. Həmin günün kalorisi, zülal/karbohidrat/yağ göstəriciləri və yeməkləri görünür.
4. Yeməyə toxunanda tərkibi (ad, qram, kalori) açılır.
5. “Bugünə qayıt” ilə geri dönün.

## Təhlükəsizlik və məxfilik

- API açarı `config.js`-dədir; `localStorage`-da saxlanılmır.
- Qeydlər, hədəf və tema yalnız cihazda (`localStorage`) qalır.
- Şəkil yalnız Google Gemini-yə göndərilir.
- Telefonu başqasına verirsinizsə: Ayarlar → “Bütün məlumatları sil”.

## Fayl strukturu

```
kalori-ai/
├── index.html            # bütün ekranlar
├── styles.css            # dizayn (işıq + qaranlıq + tema dəyişənləri)
├── app.js                # məntiq: kamera, AI, ərzaq, gündəlik, ayarlar
├── config.js             # Gemini API açarı (interfeysdə göstərilmir)
├── foods.js              # 100+ ərzağın 100 q üçün qida dəyərləri
├── sw.js                 # service worker (offline)
├── manifest.webmanifest  # PWA manifest
├── icons/                # 192, 512, maskable, apple-touch
├── tools/                # generatorlar və test skriptləri
├── baslat.cmd            # lokal server (Windows)
├── preview.png           # ekran görüntüsü
└── shots/                # test ekran görüntüləri
```

Deploy üçün `index.html`, `styles.css`, `app.js`, `config.js`, `foods.js`, `sw.js`, `manifest.webmanifest` və `icons/` lazımdır.

## Yoxlama (developer)

Testlər Chrome/Edge-i `--remote-debugging-port=9344` ilə başladıb CDP üzərindən işləyir:

```bash
node tools/shot.mjs          # iPhone ölçüsündə ekran görüntüləri + tüstü testləri
node tools/ui-test.mjs       # tema, ərzaq axtarışı/əlavə/silmə, AI recalc, gün seçimi
node tools/api-test.mjs      # Gemini sorğularını mock cavablarla yoxlayır
node tools/offline-test.mjs  # service worker və oflayn rejim
```

Real açar ilə tam axın (kvota istifadə edir):

```powershell
$env:GKEY = "AQ...."; $env:CDP_PORT = "9344"; node tools/live-test.mjs
```

## Məhdudiyyətlər

- AI **təxmin** edir: porsiya ölçüsü və yağ miqdarı həmişə dəqiq deyil. Qramları düzəltmək və AI ilə yenidən hesablamaq nəticəni dəqiqləşdirir.
- Ərzaq bazasındakı dəyərlər təxminidir (100 q üçün).
- Şəkil keyfiyyəti aşağıdırsa və ya yemək qarışıqdırsa, AI inam faizi aşağı düşür.
- Bu, tibbi məsləhət deyil.
- HEIC şəkilləri bəzi brauzerlərdə açılmaya bilər; Safari adətən avtomatik JPEG-ə çevirir.

## Növbəti addımlar (istəsəniz)

- Backend proxy — açarı serverdə gizlətmək və limitləri idarə etmək
- Barkod skaneri və məhsul bazası
- Apple Health / Google Fit inteqrasiyası
- Hesab və bulud sinxronizasiyası
