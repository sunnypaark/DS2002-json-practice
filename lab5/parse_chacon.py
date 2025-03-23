import json
import pandas as pd

with open("../data/schacon.repos.json", "r") as file:
	data = json.load(file)

df = pd.DataFrame([
	(repo["name"], repo["html_url"], repo["updated_at"], repo["visibility"])
	for repo in data
], columns=["name", "html_url", "updated_at", "visibility"])

df.head(5).to_csv("chacon.csv", index=False, header=False)
