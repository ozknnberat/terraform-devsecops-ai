from fastapi import FastAPI, Request
import google.generativeai as genai
import os
import json

app = FastAPI()

# Gemini API yapılandırması
api_key = os.getenv("GEMINI_API_KEY")
if api_key:
    genai.configure(api_key=api_key)

# Hangi modeli kullanacağımızı seçiyoruz
model = genai.GenerativeModel("gemini-flash-latest")

@app.post("/webhook")
async def receive_webhook(request: Request):
    try:
        # Checkov'dan gelen JSON verisini al
        payload = await request.json()
        
        # Checkov raporundaki "failed_checks" listesini çıkaralım (Zafiyetler)
        results = payload.get("results", {})
        failed_checks = results.get("failed_checks", [])
        
        if not failed_checks:
            return {"status": "ok", "message": "No failed checks found."}
            
        # Zafiyetleri daha düzgün bir metin haline getirelim
        vulnerabilities_text = ""
        for check in failed_checks:
            check_id = check.get("check_id", "Unknown")
            check_name = check.get("check_name", "Unknown Check")
            file_path = check.get("file_path", "Unknown File")
            code_block = check.get("code_block", [])
            
            # Kod satırlarını birleştir
            code_str = "\n".join([f"{line[0]}: {line[1]}" for line in code_block])
            
            vulnerabilities_text += f"Hata Kimliği: {check_id}\nAçıklama: {check_name}\nDosya: {file_path}\nHatalı Kod:\n```hcl\n{code_str}\n```\n\n"

        # Gemini'ye göndereceğimiz prompt
        prompt = f"""
        Sen kıdemli bir AWS ve DevSecOps uzmanısın. Aşağıda Checkov güvenlik tarayıcısı tarafından Terraform kodumda bulunan güvenlik zafiyetleri yer alıyor. 
        Lütfen bu zafiyetleri incele ve 'main.tf' dosyası için güvenli ve düzeltilmiş tam Terraform kodunu bana ver.
        Ayrıca, neyi neden değiştirdiğini kısaca Türkçe olarak açıkla.
        
        İşte Checkov Raporu:
        {vulnerabilities_text}
        """

        # Gemini'den yanıt al
        response = model.generate_content(prompt)
        ai_solution = response.text

        # Çözümü projenin kök dizinine markdown dosyası olarak kaydet
        with open("/project/ai_cozumu.md", "w", encoding="utf-8") as f:
            f.write("# Yapay Zeka Güvenlik Çözümü (DevSecOps)\n\n")
            f.write(ai_solution)

        print("Yapay Zeka çözümü başarıyla ai_cozumu.md dosyasına yazıldı!")
        return {"status": "success", "message": "Solution written to ai_cozumu.md"}

    except Exception as e:
        print(f"Hata oluştu: {str(e)}")
        return {"status": "error", "message": str(e)}

@app.get("/")
def health_check():
    return {"status": "Webhook is running"}
