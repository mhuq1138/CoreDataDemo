# CoreDataDemo
A simple Core Data application to demonstrate how Core Data is used

This application uses a data model with a single entity. It demonstrates how we can use Core Data to
1. Fetch records from the store
2. Insert new records into the store
3. Edit existing records in the store
4. Delete existing records from the store

The application uses a master-detail type interface. But we do not use the Master-Detail template. We create our own from scratch. The fetched records are displayed in a table view. Inserting a new record or editing an existing record is perform in a view controller with text fields to display the record attributes. Deleting a record is performed using the standard swipe and delete mechanism of table view.
