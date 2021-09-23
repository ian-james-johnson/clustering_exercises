import numpy as np
import pandas as pd
import os

# The env.py file contains the user credentials for the Codeup SQL database
from env import host, user, password

# Function to create a connection to the Codeup SQL database
def get_db_url(host, user, password, database):    
    url = f'mysql+pymysql://{user}:{password}@{host}/{database}'
    return url



# This functon gets Zillow data
# First the function checks for a csv file on the local drive
# If there is no locat file, then it gets the file from the Codeup database
def get_zillow_data():
    filename = "zillow.csv"
    if os.path.isfile(filename):
        return pd.read_csv(filename, index_col=0)
    else:
        # This is the database being used
        database = 'zillow'
        # This is the SQL query made to the database 
        query = '''
                SELECT prop.*, pred.logerror, pred.transactiondate, air.airconditioningdesc, arch.architecturalstyledesc, build.buildingclassdesc, heat.heatingorsystemdesc, 
                landuse.propertylandusedesc, story.storydesc, construct.typeconstructiondesc
                FROM properties_2017 prop
                INNER JOIN (SELECT parcelid, Max(transactiondate) transactiondate FROM predictions_2017 GROUP BY parcelid) pred USING (parcelid)
                JOIN predictions_2017 as pred USING (parcelid, transactiondate)
                LEFT JOIN airconditioningtype air USING (airconditioningtypeid)
                LEFT JOIN architecturalstyletype arch USING (architecturalstyletypeid)
                LEFT JOIN buildingclasstype build USING (buildingclasstypeid)
                LEFT JOIN heatingorsystemtype heat USING (heatingorsystemtypeid)
                LEFT JOIN propertylandusetype landuse USING (propertylandusetypeid)
                LEFT JOIN storytype story USING (storytypeid)
                LEFT JOIN typeconstructiontype construct USING (typeconstructiontypeid)
                WHERE prop.latitude IS NOT NULL AND prop.longitude IS NOT NULL
                LIMIT 1000
                '''

        # Convert the SQL query result into a pandas dataframe
        # get_db_url is another function in this file
        df = pd.read_sql(query, get_db_url(host, user, password, database))

        # Write that dataframe to csv on local drive, so that I won't need to access the database later
        df.to_csv(zillow.csv)

        # Return the dataframe for immediate use
        return df





