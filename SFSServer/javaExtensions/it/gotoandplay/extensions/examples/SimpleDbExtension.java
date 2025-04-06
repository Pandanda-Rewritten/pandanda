package it.gotoandplay.extensions.examples;

import java.util.ArrayList;
import java.util.LinkedList;

import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.db.DataRow;
import it.gotoandplay.smartfoxserver.db.DbManager;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

/**
 * SimpleDbExtension.java
 * 
 * This example is the java translation of the dbExtension Actionscript Example
 * found in the <b>sfsExtensions/ folder</b>
 * <br>
 * For further details you should read the tutorial 8.3 of the SmartFoxServer documentation
 * 
 * @author Marco Lapi<br>
 * (c) 2005 gotoAndPlay() -- www.gotoandplay.it
 *
 */
public class SimpleDbExtension extends AbstractExtension
{
	private ExtensionHelper helper;
	private DbManager db;
	private Zone currZone;
	
	/**
	 * Init extension
	 */
	public void init()
	{
		// Get Helper
		helper = ExtensionHelper.instance();
		
		// Get the current zone
		currZone = helper.getZone(this.getOwnerZone());
		
		// Get database manager
		db = currZone.dbManager;
	}
	
	
	/**
	 * Destroy / release resources
	 */
	public void destroy()
	{
		db = null;
	}

	/**
	 * Handle client requests sent in XML format.
	 * The AS objects sent by the client are serialized to an ActionscriptObject
	 * 
	 * @param ao 		the ActionscriptObject with the serialized data coming from the client
	 * @param cmd 		the cmd name invoked by the client
	 * @param fromRoom 	the id of the room where the user is in
	 * @param u 		the User who sent the message
	 */
	public void handleRequest(String cmd, ActionscriptObject ao, User u, int fromRoom)
	{
		if (cmd.equals("getData"))
		{
			// SQL statement to execute
			String sql = "SELECT * FROM contacts ORDER BY name";
			
			// Execute the SQL statement
			ArrayList queryRes = db.executeQuery(sql);
			
			// Main response object
			ActionscriptObject response = new ActionscriptObject();
			
			// Set the command name for the response
			response.put("_cmd", "getData");
			
			// Nested array object (response.db)
			ActionscriptObject db_array = new ActionscriptObject();
			
			// If data exist...
			if (queryRes != null && queryRes.size() > 0)
			{
				// Cycle through all rows of data
				for (int i = 0; i < queryRes.size(); i++)
				{
					// Get a row of data
					DataRow row = (DataRow) queryRes.get(i);
					
					// Create an empty AS object
					ActionscriptObject as_obj = new ActionscriptObject();
					
					// Add data to the AS object
					as_obj.put("name", row.getItem("name"));
					as_obj.put("location", row.getItem("location"));
					as_obj.put("email", row.getItem("email"));
					
					// Add data object to the array
					db_array.put(i, as_obj);
				}
				
				// Add db_array to main response object
				response.put("db", db_array);
			}
			else
				trace("DB Query failed");
			
			// Prepare a list of recipients and put the user that requested the command
			LinkedList recipients = new LinkedList();
			recipients.add(u.getChannel());
			
			// Send data to client
			sendResponse(response, fromRoom, u, recipients);
			
		}
	}
	
	
	/**
	 * Handle client requests sent in String format.
	 * The parameters sent by the client are split in a String[]
	 * 
	 * @param params 	an array of data coming from the client
	 * @param cmd 		the cmd name invoked by the client
	 * @param fromRoom 	the id of the room where the user is in
	 * @param u 		the User who sent the message
	 */
	public void handleRequest(String cmd, String[] params, User u, int fromRoom)
	{
		// Not used here
	}
	
	/**
	 * Handles an event dispateched by the Server
	 * @param ieo the InternalEvent object
	 */
	public void handleInternalEvent(InternalEventObject ieo)
	{
		// We don't need to handle events here
	}

}
