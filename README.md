# 🛡️ AI-Driven DevSecOps Pipeline

Modern yazılım geliştirme döngüsünde "Shift-Left Security" (Güvenliği en başa çekme) prensibini uygulayan, yapay zeka destekli tam otomatik bir DevSecOps boru hattı (pipeline) projesidir.

Bu sistem, AWS altyapısındaki zafiyetleri sadece tespit etmekle kalmaz; Google Gemini AI kullanarak bu zafiyetleri otomatik olarak analiz eder ve düzeltilmiş güvenli altyapı kodlarını (IaC) saniyeler içinde üretir.

## 🚀 Özellikler
* **Statik Kod Analizi (SAST):** Checkov kullanılarak Terraform kodlarındaki güvenlik zafiyetleri (Örn: Açık S3 Bucket'lar, 0.0.0.0'a açık SSH portları vb.) anında tespit edilir.
* **Yapay Zeka İle Otomatik İyileştirme (Auto-Remediation):** Tespit edilen zafiyetler, FastAPI ile yazılmış özel bir Webhook servisi aracılığıyla Google Gemini AI'a iletilir. AI, zafiyeti açıklayan ve güvenli kodu barındıran bir çözüm reçetesi üretir.
* **CI/CD Otomasyonu:** GitHub Actions entegrasyonu sayesinde hatalı kodların canlı ortama (production) gitmesi kesin olarak engellenir.
* **İzole Geliştirme Ortamı:** Docker ve Docker Compose ile tüm süreç platform bağımsız ve izole hale getirilmiştir.

## 🛠️ Kullanılan Teknolojiler
* **Infrastructure as Code (IaC):** Terraform
* **Güvenlik & Tarama:** Checkov
* **Backend & Webhook:** Python, FastAPI, Docker
* **Yapay Zeka:** Google Generative AI (Gemini API)
* **CI/CD:** GitHub Actions
* **Bulut Sağlayıcı Hedefi:** AWS

## 💻 Sistem Nasıl Çalışıyor?
1. Geliştirici hatalı veya güvensiz bir Terraform kodunu GitHub'a pushlar.
2. **GitHub Actions** tetiklenir ve **Checkov** taramasını başlatır.
3. Checkov zafiyet bulduğunda pipeline'ı durdurur (Failed) ve raporu **FastAPI Webhook** servisine gönderir.
4. Servis, **Gemini AI** ile iletişim kurarak zafiyetin HCL formatında çözümünü ve açıklamalarını üretir.
5. Geliştirici, AI'ın ürettiği güvenli kodu uygular ve tekrar pushlar. Pipeline başarıyla tamamlanır (Success).

---
*Not: Bu repo eğitim ve konsept kanıtlama (PoC) amacıyla oluşturulmuştur.*
