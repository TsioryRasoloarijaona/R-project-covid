from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import requests

def download_data(url_file, file_id):
    url = url_file
    destination = f"/home/tsiory/Documents/cours_1è_année_ingenieur/stat_data/covid-project/data/data_{file_id}.pdf"
    try:
        response = requests.get(url, stream=True, verify=False)
        response.raise_for_status()

        with open(destination, "wb") as file:
            for chunk in response.iter_content(chunk_size=8192):
                file.write(chunk)

        print(f"Fichier téléchargé avec succès : {destination}")
    except requests.exceptions.RequestException as e:
        print(f"Erreur lors du téléchargement : {e}")


def download_urls():
    driver = webdriver.Chrome()
    driver.get('https://www.covidmaroc.ma/Pages/LESINFOAR.aspx')

    
    links = WebDriverWait(driver, 30).until(
        EC.presence_of_all_elements_located((By.XPATH, "//*[@id='WebPartWPQ1']//table//a[contains(@href, 'Documents')]"))
    )

    hrefs = []

   
    for link in links:
        try:
            href = link.get_attribute('href')
            if href:  
                hrefs.append(href)
        except Exception as e:
            print(f"Error getting the file links : {e}")

    driver.quit()

    return hrefs



hrefs = download_urls()

print(f"Nombre de fichiers à télécharger : {len(hrefs)}")


file_id = 971
for href in hrefs:
    download_data(href, file_id)
    file_id += 1
