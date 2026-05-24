# 🛡️ AI-Driven DevSecOps Pipeline

Modern yazılım geliştirme döngüsünde "Shift-Left Security" (Güvenliği en başa çekme) prensibini uygulayan, yapay zeka destekli tam otomatik bir DevSecOps boru hattı (pipeline) projesidir.

Bu sistem, AWS altyapısındaki zafiyetleri sadece tespit etmekle kalmaz; Google Gemini AI kullanarak bu zafiyetleri otomatik olarak analiz eder ve düzeltilmiş güvenli altyapı kodlarını (IaC) saniyeler içinde üretir.

## 🚀 Özellikler
* **Statik Kod Analizi (SAST):** Checkov kullanılarak Terraform kodlarındaki güvenlik zafiyetleri (Örn: Açık S3 Bucket'lar, 0.0.0.0'a açık SSH portları vb.) anında tespit edilir.
* **Yapay Zeka İle Otomatik İyileştirme (Auto-Remediation):** Tespit edilen zafiyetler, FastAPI ile yazılmış özel bir Webhook servisi aracılığıyla Google Gemini AI'a iletilir. AI, zafiyeti açıklayan ve güvenli kodu barındıran bir çözüm reçetesi üretir.
* **CI/CD Otomasyonu:** GitHub Actions entegrasyonu sayesinde hatalı kodların canlı ortama (production) gitmesi kesin olarak engellenir.
* **İzole Geliştirme Ortamı:** Tüm Webhook ve arka plan işlemleri, bağımlılık çakışmalarını önlemek için tamamen **Docker** ve **Docker Compose** ortamında izole edilmiş olarak çalışır.

## 🛠️ Kullanılan Teknolojiler
* **Infrastructure as Code (IaC):** Terraform
* **Güvenlik & Tarama:** Checkov
* **Backend & Webhook:** Python, FastAPI, Uvicorn
* **Konteynerizasyon:** Docker, Docker Compose
* **Yapay Zeka:** Google Generative AI (Gemini API)
* **CI/CD:** GitHub Actions

## 💻 Sistem Nasıl Çalışıyor?
1. Geliştirici hatalı veya güvensiz bir Terraform kodunu GitHub'a pushlar.
2. **GitHub Actions** tetiklenir ve **Checkov** taramasını başlatır.
3. Checkov zafiyet bulduğunda pipeline'ı durdurur (Failed) ve raporu, **Docker** içerisinde koşan **FastAPI Webhook** servisine gönderir.
4. Servis, **Gemini AI** ile iletişim kurarak zafiyetin HCL formatında çözümünü ve açıklamalarını (ai_cozumu.md) üretir.
5. Geliştirici, AI'ın ürettiği güvenli kodu uygular ve tekrar pushlar. Pipeline başarıyla tamamlanır (Success).

---

## 🚀 Kurulum ve Çalıştırma (Kendi Ortamınızda Deneyin)

Bu projeyi bilgisayarınızda ayağa kaldırmak ve yapay zeka entegrasyonunu denemek oldukça basittir. Proje, yerel makinenize herhangi bir dil (Python, Terraform vb.) kurmanıza gerek kalmadan tamamen **Docker** üzerinden çalışacak şekilde tasarlanmıştır.

### Ön Koşullar
* Bilgisayarınızda **Docker Desktop**'ın kurulu ve çalışıyor olması.
* Bir adet [Google Gemini API Key](https://aistudio.google.com/) temin edilmesi.

### Adım 1: Projeyi Klonlayın
```bash
git clone https://github.com/ozknnberat/terraform-devsecops-ai.git
cd terraform-devsecops-ai
```

### Adım 2: Çevre Değişkenlerini (API Key) Ayarlayın
Proje ana dizininde bir `.env` dosyası oluşturun ve içine Gemini API anahtarınızı yapıştırın:
```text
GEMINI_API_KEY=sizin_gemini_api_anahtariniz_buraya_gelecek
```

### Adım 3: AI Webhook Sunucusunu Docker ile Başlatın
Webhook servisinin bağımlılıkları indirmesi ve 8000 portunda dinlemeye başlaması için şu komutu çalıştırın:
```bash
docker-compose up -d webhook
```
Bu komut sayesinde arka planda izole bir Docker container'ı ayağa kalkacak ve olası bir güvenlik açığında AI ile iletişime geçmek için hazırda bekleyecektir.

### Adım 4: Hata Fırlatarak Sistemi Test Edin
İsterseniz GitHub Actions üzerinden kodu pushlayarak süreci test edebilir veya lokal ortamınızda sahte bir hata göndererek sistemin çalışmasını anında görebilirsiniz:
```powershell
Invoke-RestMethod -Uri http://localhost:8000/webhook -Method Post -InFile mock_payload.json -ContentType "application/json"
```
Bu komutu tetiklediğinizde, sunucunuz Gemini AI ile iletişime geçecek ve klasörünüzün içinde `ai_cozumu.md` isimli çözüm reçetesini saniyeler içinde oluşturacaktır!

---
*Not: Bu repo eğitim ve konsept kanıtlama (PoC) amacıyla oluşturulmuştur.*
