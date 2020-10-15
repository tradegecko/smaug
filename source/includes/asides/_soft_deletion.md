# Soft Deletion

QuickBooks Commerce uses soft-deletion for most of its records. 
In the API, a soft-deleted object will have a status of `archived`. 
These records will not be returned by default, but can be accessed using filters to 
specifically return records with a status of `archived`.
