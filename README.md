# Plugin for Redmine 'IssueDocs'

Creates a new Google document while creating a new issue in Redmine and puts share link for the doc to Custom field of the issue 

### Google service account credentials

This plugin uses credentials of Google service account, which must be put at the file `'lib/issue-docs/service-account-creds.json’`. It is empty now.

To create Google service account do next steps:
1. Visit https://console.developers.google.com and create the application
2. Switch on Google Drive API
3. Create credentials for service account (service account key). As a result, the credentials will be saved to json file on your computer. Copy the content of this file and insert it to `'lib/issue-docs/service-account-creds.json’`

There is an instruction (in Russian) https://docs.google.com/document/d/1VNxvQz19p75b9DRk-Q0aqjZaKpr-fHQ8r8Ld4yK0FB8/edit?usp=sharing 

### Listing and deleting files on he Google Disk

There is ruby script for listing and deleting files on the Google Disk of this service account `'lib/issue-docs/list_and_delete_files_on_google_disk.rb’`. 

Run this file in terminal like any other ruby file:

``` $ ruby redmine/plugins/issue_google_docs/lib/issue_docs/list_and_delete_files_on_google_disk.rb```

Keep in mind that this script also depends on service account credentials (line 12, file `'service-account-creds.json'`)
