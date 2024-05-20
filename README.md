# Project EMERGE

The EMERGE project is dedicated to advancing sustainability in Africa by providing key stakeholders with essential tools and knowledge.
This repo is dedicated to the storage and upkeep of the database that enables these data-driven tools.



## Tools
Below is the list of tools that utilize the database. Find more details about them in their README files.
- Cepia
- OSeMOSYS
- CIRCE (HOSTING CAPACITY & OPTIMAL STORAGE PLACEMENT)
- GREENADVISE
- PowSyBl - METRIX



## How To Use
Repo uses python version `X.Y`

EMERGE database is hosted on `AWS RDS ??`, but you can also create local databases for testing. To do so, make sure you have postgres installed, and some local client for using postgres, like `psql`.

Knowing what files to run is generally dependent on what you're trying to accomplish. This repo is not an app that can be run, but rather a record of all SQL operations performed, and knowledge how to (re-)create tables.



### Creating the schema
Creating the schema from scratch can be done running the script `emerge.sql`


### Ingesting data into schema
Currently the available data is ingested per tool within the respective directory (e.g. `greenadvise_ingest.py`). This is subject to change as the project develops, more data becomes available, and automated data ingestion becomes a requirement.


### Downloading data
Project requires an easy way to download the data in various formats that different stakeholders can use, which can be achieved using the `download.py` script

