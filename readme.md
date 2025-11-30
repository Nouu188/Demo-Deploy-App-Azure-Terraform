Create an application with these requirement:
- Using node 20, using express js
- has an endpoint /add-line
- everytime it is called, will add 1 record to postgresql as timesctamp and small quote
- write docker compose has 2 services as api and db, let the connection string as envoronment variable
-----
terraform

create the terraform script with this requirement:
- has VNet named Demo-vnet
- 2 subnet as api-subnet and db-subnet
- in api-subnet create an appservice which use the current application that we already have now which is in quotes-api, in db, create the postgressql for the api to connect to.
- rememeber to use the most cost effective selection, as much free as possible
