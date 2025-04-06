package it.gotoandplay.extensions.examples;

import java.nio.channels.SocketChannel;
import java.util.*;


import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.data.Zone;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.exceptions.ExtensionHelperException;
import it.gotoandplay.smartfoxserver.exceptions.LoginException;
import it.gotoandplay.smartfoxserver.extensions.*;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

/**
 * 
 * PixelGame -- SmartFoxServer example Extension
 * version 1.0.0
 * 
 * @author Marco Lapi<br>
 * (c) 2005 gotoAndPlay() -- www.gotoandplay.it
 *
 * 
 */
public class PixelGame extends AbstractExtension
{

	//--- Grid size -------------------
	private static int gX = 30;
	private static int gY = 30;
	
	private int roomCounter;
	private String currZone;
	private Zone zone;
	private ExtensionHelper helper;
	
	
	/**
	 * Extension initialization
	 */
	public void init()
	{
		this.trace("Pixel game etxension started...");

		roomCounter = 0;
		
		currZone 	= this.getOwnerZone();
		helper		= ExtensionHelper.instance();
		
		zone		= helper.getZone(currZone);
		
		// Init server rooms
		Object[] rList = zone.getRooms();
		
		for (int i = 0; i < rList.length; i++)
			createGrid((Room) rList[i]);
	}
	
	/**
	 * This is not used. The client will send and receive data from the extension
	 * in String format, to allow better bandwidth usage.
	 */
	public void handleRequest(String cmd, ActionscriptObject ao, User u, int fromRoom)
	{
		
	}
	
	/**
	 * Handle internal events
	 */
	public void handleInternalEvent(InternalEventObject ieo)
	{
		if (ieo.getEventName().equals("loginRequest"))
		{
			boolean ok = false;
			
			User newUser = null;
			
			String nick = ieo.getParam("nick");
			String pass = ieo.getParam("pass");
			SocketChannel chan = (SocketChannel) ieo.getObject("chan");
			
			ActionscriptObject res = new ActionscriptObject();
			
			if (nick.equals(""))
				nick = getRandomName(12);
			trace("LOGIN " + nick);
			try
			{
				newUser = helper.canLogin(nick, pass, chan, currZone);
				
				res.put("_cmd", "logOK");
				res.put("id", String.valueOf(newUser.getUserId()));
				res.put("name", newUser.getName());
				
				ok = true;
			}
			catch (LoginException le)
			{
				this.trace("Could not login user: " + nick);
				
				res.put("_cmd", "logKO");
				res.put("err", le.getMessage());
			}
			
			LinkedList ll = new LinkedList();
			ll.add(chan);
			
			// Send login response
			sendResponse(res, -1, null, ll);	
			
			// Send room list
			if (ok)
				helper.sendRoomList(chan);
		}
	}
	
	
	/**
	 * Hanlde client requests in String format
	 */
	public void handleRequest(String cmd, String params[], User u, int fromRoom)
	{
		if (cmd.equals("jme"))
			lookForRoom(u);
		
		else if (cmd.equals("grid"))
			sendStatus(u, fromRoom);
		
		else if (cmd.equals("upd"))
			handleUpdate(params, u, fromRoom);
			
	}
	
	
	/**
	 * handle pixel update
	 * 
	 * @param params		array of params from client
	 * @param who			the user who sent the update
	 * @param fromRoom		the room in which the update occurred
	 */
	private void handleUpdate(String[] params, User who, int fromRoom)
	{
		Room r = zone.getRoom(fromRoom);
		
		// Check if the room exist
		if (r != null)
		{
			// Get the grid array for the current room
			char[][] grid = (char[][]) r.properties.get("grid");

			try
			{
				char ch = params[0].charAt(0);				// state of the grid cell
				int px = Integer.parseInt(params[1]);		// x of the grid cell
				int py = Integer.parseInt(params[2]);		// y of the grid cell
				
				//System.out.println("px = " + px + ", py = " + py + ", ch = " + ch);
				
				// Set the grid
				grid[py][px] = ch;
				
				// Prepare response for the client
				String[] res = {"upd", params[0], params[1], params[2]};
						
				// All users except "who"
				LinkedList allButMe = r.getChannellList();
				allButMe.remove(who.getChannel());
				
				// Send response to clients
				sendResponse(res, fromRoom, who, allButMe);
				
			}
			catch (NumberFormatException nfe)
			{
				this.trace("Bad number values in update request!");
			}
			catch(ArrayIndexOutOfBoundsException aioobe)
			{
				this.trace("Bad grid indexes in update request!");
			}
		}
		
	}

	/**
	 * Look for a room to join the client in
	 * @param u	the user to join
	 */
	private void lookForRoom(User u)
	{
		// Get a list of rooms available
		Object[] rList = zone.getRooms();
		
		Room room = null;
		
		boolean found = false;
		
		// Cycle through all rooms
		for (int i = 0; i < rList.length; i++)
		{
			room = (Room) rList[i];
			
			// Check there's at least one user slot available
			if (room.howManyUsers() < room.getMaxUsers())
			{
				try
				{
					// Room found! Let's join the user inside
					trace("Found a room for user >> " + room.getName());
					helper.joinRoom(u, -1, room.getId(), false, "", false, true);
					
					found = true;
					break;
				}
				catch (ExtensionHelperException ehe)
				{
					this.trace("Oops, user: " + u.getName() + " couldn't join. Reason: " + ehe.getMessage());
				}
			}
		}
		
		// ... a free slot was not found, let's make a new room
		if (!found)
		{
			// Create an automatic name for the room
			String rName = "AutoRoom_" + roomCounter;
			roomCounter++;
			
			// Create room
			Room newRoom = makeNewRoom(rName, 4, u);
			
			if (newRoom != null)
			{
				// Setup the data grid for the new room
				createGrid(newRoom);
				
				try
				{
					// Join the new room!
					helper.joinRoom(u, -1, newRoom.getId(), false, "", false, true);
				}
				catch(ExtensionHelperException ehe)
				{
					this.trace("Oops, user: " + u.getName() + " couldn't join. Reason: " + ehe.getMessage());
				}
			}
		}
		
	}
	
	
	
	/**
	 * Make a new Room
	 * 
	 * @param name	the room name
	 * @param maxU	the max users in that room
	 * @param u		the owner / creator of the room
	 * 
	 * @return		the new room obj
	 */
	private Room makeNewRoom(String name, int maxU, User u)
	{
		Room newRoom = null;
		
		// Here we pass the room parameters
		HashMap map = new HashMap();
		map.put("name", name);
		map.put("pwd", "");
		map.put("maxU", String.valueOf(maxU));
		map.put("maxS", "0");
		map.put("isGame", "false");
		
		try
		{
			newRoom = helper.createRoom(zone, map, u, true, true);
		}
		catch(ExtensionHelperException ehe)
		{
			this.trace("Could not create room: " + name + ", Reason: " + ehe.getMessage());
		}
		
		return newRoom;
	}
	
	
	
	/**
	 * Initialize grid for a Room r
	 * 
	 * @param r		the room
	 */
	private void createGrid(Room r)
	{
		// Create the 2d array to hold the pixel data
		char[][] grid = new char[gY][gX];
		
		// Initialize the grid
		for (int y = 0; y < gY; y++)
		{
			for (int x = 0; x < gX; x++)
			{
				grid[y][x] = '0';
			}
		}
		
		// Attach the grid to the room
		r.properties.put("grid", grid);
	}
	
	
	
	/**
	 * Send the current grid status
	 * 
	 * @param who		the user
	 * @param roomId	the room
	 */
	private void sendStatus(User who, int roomId)
	{
		// Get the room object
		Room r = zone.getRoom(roomId);
		
		if (r != null)
		{
			// Get the pixel data
			char[][] grid = (char[][]) r.properties.get("grid");

			// Prepare the response in a StringBuffer
			StringBuffer gridData = new StringBuffer();
			
			// Add all characters from the 2D array in the buffer
			for (int y = 0; y < gY; y++)
			{
				for (int x = 0; x < gX; x++)
				{
					gridData.append(grid[y][x]);
				}
			}
			
			// Prepare response
			String[] res = {"grid", gridData.toString()};
					
			// All users except "who"
			LinkedList ll = new LinkedList();
			ll.add(who.getChannel());
			
			// Send response the client list
			sendResponse(res, roomId, who, ll);
		}
	}
	
	/**
     * Return a random name made of lowercase characters
     * 
     * @param n	the length of the String
     * @return 	a String of n chars
     */
    private String getRandomName(int n)
    {
    	StringBuffer sb = new StringBuffer();
    	Random rnd = new Random();
    	
    	for (int i = 0; i < n; i++)
    	{
    		int r = rnd.nextInt(26);
    		sb.append(((char) (97 + r)));
    	}
    	
    	return sb.toString();
    }
    
    
    // Debug only
    private void dumpGrid(char[][] grid)
    {		
		// Add all lines
		for (int y = 0; y < gY; y++)
		{
			for (int x = 0; x < gX; x++)
			{
				System.out.print(grid[y][x]);
			}
			
			System.out.println("");
		}
    }
}
