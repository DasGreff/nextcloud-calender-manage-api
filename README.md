# Nextcloud Calendar API

## Description

API REST pour gérer les calendriers Nextcloud via CalDAV. Permet de créer, supprimer et consulter des événements depuis des scripts d'automatisation.

**Basé sur :** [murajo/nextcloud-calender-manage-api](https://github.com/murajo/nextcloud-calender-manage-api)

## Fonctionnalités

- 📅 Lister les calendriers
- ➕ Créer des événements  
- 🗑️ Supprimer des événements
- 📋 Lister les événements
- ✅ Vérifier l'existence d'événements

## Prérequis

- Nextcloud avec CalDAV
- Compte utilisateur Nextcloud
- Docker

## Configuration

Configurez le fichier `env` :

```bash
NEXTCLOUD_URL="https://votre-nextcloud.com/remote.php/dav"
NEXTCLOUD_USERNAME="votre_utilisateur"
NEXTCLOUD_PASSWORD="votre_mot_de_passe"
VERIFY_SSL="true"
```

## Installation

### Docker (recommandé)

```bash
# Construction
docker build -t nextcloud-calendar-api .

# Exécution
docker run -d --name nextcloud-calendar-api --env-file env -p 5000:5000 nextcloud-calendar-api
```

### Local

```bash
pip install -r requirements.txt
python src/app.py
```

## API Endpoints

L'API écoute sur le port 5000 :

### Lister les calendriers
```bash
GET /calendars
```

### Ajouter un événement
```bash
POST /add_event
Content-Type: application/json

{
  "calendar_name": "Personnel",
  "start_time": "2025-10-25T14:00:00",
  "end_time": "2025-10-25T15:00:00",
  "summary": "Réunion importante",
  "description": "Discussion sur le projet",
  "timezone": "Europe/Paris"
}
```

### Supprimer un événement
```bash
DELETE /delete_event
Content-Type: application/json

{
  "calendar_name": "Personnel",
  "summary": "Réunion importante"
}
```

### Lister les événements
```bash
GET /events?calendar_name=Personnel
```

### Vérifier l'existence
```bash
GET /event_exists?calendar_name=Personnel&summary=Réunion importante
```

## Exemples

### Avec curl

```bash
# Lister les calendriers
curl http://localhost:5000/calendars

# Ajouter un événement
curl -X POST http://localhost:5000/add_event \
  -H "Content-Type: application/json" \
  -d '{
    "calendar_name": "Personnel",
    "start_time": "2025-12-25T10:00:00",
    "end_time": "2025-12-25T12:00:00",
    "summary": "Repas de Noël"
  }'
```

### Avec Python

```python
import requests

# Ajouter un événement
requests.post("http://localhost:5000/add_event", json={
    "calendar_name": "Personnel",
    "start_time": "2025-11-15T09:00:00",
    "end_time": "2025-11-15T10:00:00",
    "summary": "Rendez-vous médecin"
})
```

## Format des données

**Format des dates :** `YYYY-MM-DDTHH:MM:SS`  
**Timezone :** `Europe/Paris`, `UTC`, etc.

**Codes de retour :**
- 200 : Succès
- 400 : Données invalides  
- 500 : Erreur serveur

## Dépannage

**Erreur de connexion :** Vérifiez `NEXTCLOUD_URL`, `USERNAME`, `PASSWORD`  
**Calendrier introuvable :** Listez d'abord les calendriers avec `/calendars`  
**Erreurs SSL :** Définissez `VERIFY_SSL="false"` pour les tests

```bash
# Test de l'API
curl http://localhost:5000/calendars

# Logs Docker
docker logs nextcloud-calendar-api
```

## Crédits

Basé sur [nextcloud-calender-manage-api](https://github.com/murajo/nextcloud-calender-manage-api) par [@murajo](https://github.com/murajo).
