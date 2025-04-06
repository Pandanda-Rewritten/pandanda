package it.gotoandplay.extensions.examples;

import java.lang.reflect.Array;
import java.util.HashMap;
import java.util.LinkedList;

import it.gotoandplay.smartfoxserver.data.Room;
import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

public class SFSTris2 extends AbstractExtension
{
	private ExtensionHelper helper;
	private String [][] board;						// A 2D array containing the board game data
	private HashMap<Integer, User> users;			// An array of users
	private int whoseTurn;							// Keep track of the current turn
	private int numPlayers;							// Count the number of players currently inside
	private boolean gameStarted;					// True if the game has started
	private int currentRoomId;						// The Id of the room where the extension is running
	private int p1id;								// UserId of player1
	private int p2id;								// UserId of player2
	private int moveCount;							// Count the number of moves
	private ActionscriptObject endGameResponse;		// Save the final result of the game
	
	/**
	 * Initialize the extension.<br>
	 * It's always good practice to keep a reference to the ExtensionHelper object
	 */
	public void init()
	{
		helper = ExtensionHelper.instance();
		
		trace("The SFSTris2 Extension is initializing");
		users = new HashMap<Integer, User>();
		whoseTurn = 0;
		numPlayers = 0;
		gameStarted = false;
		currentRoomId = -1;
		p1id = -1;
		p2id = -1;
		endGameResponse = new ActionscriptObject();
	}
	
	
	/**
	 * Destroy the extension
	 */
	public void destroy()
	{
		trace("The SFSTris Extension is shutting down");
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
		// Player ready to play (game loaded succesfully)
		if (cmd.equalsIgnoreCase("ready"))
		{
			// Get the id of the current room
			currentRoomId = fromRoom;
			
			// Add the user to our list of local users in this game room
			// We use the userId number as the key
			users.put(u.getUserId(), u);
			
			// Handle player entering game
			// Let's check if the player is not a spectator (playerIndex != -1)
			if (u.getPlayerIndex() != -1)
			{
				numPlayers++;
				
				if (u.getPlayerIndex() == 1)
					p1id = u.getUserId();
				else
					p2id = u.getUserId();
				
				// If we have two players and the game was not started yet, it's time to start it now!
				if(numPlayers == 2 && !gameStarted)
					startGame();
			}
			else
			{
				// If a spectator enters the room we have to update him sending the current board status
				updateSpectator(u);
				
				if (endGameResponse != null)
				{
					LinkedList ll = new LinkedList();
					ll.add(u.getChannel());
					
					sendResponse(endGameResponse, currentRoomId, null, ll);
				}
			}
		}
		
		// Player moves
		else if (cmd.equalsIgnoreCase("move"))
		{
			handleMove(ao, u);
		}
		
		// Restart game
		else if (cmd.equalsIgnoreCase("restart"))
		{
			System.out.println("Restart command received");
			System.out.println("numPlayers: " + numPlayers);
			System.out.println("gameStarted: " + gameStarted);
			// If we have two players and the game was not started yet, it's time to start it now!
			if(numPlayers == 2 && !gameStarted)
				startGame();
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
		trace("The command -> " + cmd + " was invoked by user -> " + u.getName());
	}


	/**
	 * Handles an event dispateched by the Server
	 * @param ieo the InternalEvent object
	 */
	public void handleInternalEvent(InternalEventObject ieo)
	{
		String evtName = ieo.getEventName();
        
        // Handle a user leaving the room or a user disconnection
		if (evtName.equals("userExit") || evtName.equals("userLost"))
		{
			// Get the user id
			int uId = Integer.valueOf(ieo.getParam("uid"));
			
			// Get the playerId of the user we have lost
			int oldPid = 0;
			
			if (evtName.equals("userExit"))
				oldPid = Integer.valueOf(ieo.getParam("oldPlayerIndex"));
			else if (evtName.equals("userLost"))
			{
				int[] playerIndexes = (int[]) ieo.getObject("playerIndexes");
				oldPid = playerIndexes[0];
			}
			
			User u = users.get(uId);
			
			// Let's remove the player from the list
			users.remove(uId);
			
			// If the user we have lost was playing
			// we stop the game and tell everyone
			if (oldPid > 0)
			{
				numPlayers--;
				
				gameStarted = false;
				
				if (oldPid == 1)
					p1id = -1;
				else if  (oldPid == 2)
					p2id = -1;
				
				if(numPlayers > 0)
				{
					ActionscriptObject res = new ActionscriptObject();
					res.put("_cmd", "stop");
					res.put("n", u.getName());
					
					sendResponse(res, currentRoomId, null, getUsersChannels());
				}
			}
		}
		
		// Handle a spectator switching to a player
		else if (evtName.equals("spectatorSwitched"))
		{
			User u = (User)ieo.getObject("user");
			int playerIndex = Integer.valueOf(ieo.getParam("playerIndex"));
			
			if (!gameStarted && playerIndex > 0)
			{
				numPlayers++;
				
				// Update the playerId
				if (playerIndex == 1)
					p1id = u.getUserId();
				else if (playerIndex == 2)
					p2id = u.getUserId();
				
				// If we now have 2 players the game should be started
				if(numPlayers == 2)
					startGame();
			}
		}
	}
	
	/*
	* Initialize the game board as a 2D array
	* 
	* We use 1 as the starting index instead of 0, so the array has an null value in pos 0
	*/
	public void initGameBoard()
	{
		board = new String[4][4];
		
		for (int i = 1; i < 4; i++)
			for (int j = 1; j < 4; j++)
				board[i][j] = ".";
	}

	/*
	* This method starts the game
	* 
	* We send a message to the current list of users telling that the game is started
	* We also send the name and id of the two players
	* 
	*/
	public void startGame()
	{
		gameStarted = true;
		
		initGameBoard();
		
		moveCount = 0;
		endGameResponse = null;
		
		if (whoseTurn == 0)
			whoseTurn = 1;
		
		ActionscriptObject res = new ActionscriptObject();
		res.put("_cmd", "start");
		res.putNumber("t", whoseTurn);
		res.put("p1n", users.get(p1id).getName());
		res.putNumber("p1i", p1id);
		res.put("p2n", users.get(p2id).getName());
		res.putNumber("p2i", p2id);
		
		sendResponse(res, currentRoomId, null, getUsersChannels());
	}
	
	
	private LinkedList getUsersChannels()
	{
		LinkedList ll = new LinkedList();
		for (User user : users.values())
			if (user != null)
				ll.add(user.getChannel());
		
		return ll;
	}
	
	
	/*
	* Here we update the spectator that has entered the game after it was started
	* We send him the current board status and the player names and ids
	*/
	public void updateSpectator(User user)
	{
		ActionscriptObject res = new ActionscriptObject();
		
		res.put("_cmd", "specStatus");
		res.putNumber("t", whoseTurn);
		res.putBool("status", gameStarted);
		
		if (board != null)
		{
			ActionscriptObject gameBoard = new ActionscriptObject();
			res.put("board", gameBoard);
	
			// Create grid
			for (int y = 0; y < 4; y++)
			{
			   ActionscriptObject column = new ActionscriptObject();
			   gameBoard.put(y, column);
			   
			   for (int x = 0; x < 4; x++)
			      column.put(x, board[y][x]);
			}
		}
		
		res.putNumber("p1i", p1id);
		if (p1id > -1)
			res.put("p1n", users.get(p1id).getName());
		
		res.putNumber("p2i", p2id);
		if (p2id > -1)
			res.put("p2n", users.get(p2id).getName());
		
		LinkedList ll = new LinkedList();
		ll.add(user.getChannel());
		
		sendResponse(res, currentRoomId, null, ll);
	}



	/*
	* This method handles a move sent by the client
	* The move is validated before accepting it, then it is broadcasted back to all clients
	*/
	public void handleMove(ActionscriptObject prms, User u)
	{
		if (gameStarted)
		{
			if (whoseTurn == u.getPlayerIndex())
			{
				int px = (int)prms.getNumber("x");
				int py = (int)prms.getNumber("y");
				
				if (board[py][px] == ".")
				{
					board[py][px] = String.valueOf(u.getPlayerIndex());
					
					whoseTurn = (whoseTurn == 1) ? 2 : 1;
					
					ActionscriptObject res = new ActionscriptObject();
					
					res.put("_cmd", "move");
					res.putNumber("t", u.getPlayerIndex());
					res.putNumber("x", px);
					res.putNumber("y", py);
					
					sendResponse(res, currentRoomId, null, getUsersChannels());
					moveCount++;
					
					checkBoard();
				}
			}
		}
	}


	/*
	* This function checks if someone is winning!
	* 
	* It checks all three horizontal lines, all three vertical lines and the two diagonals
	* If no one wins and all board tiles are taken then it's a tie!
	* 
	* The function is called after every player move
	*/
	private void checkBoard()
	{
		String [] solution = new String[8];
		int cnt = 0;
		
		// All Rows
		for (int i = 1; i < 4; i++)
		{
			solution[cnt] = (board[i][1] + board[i][2] + board[i][3]);
			cnt++;
		}
		
		// All Columns
		for (int i = 1; i < 4; i++)
		{
			solution[cnt] = (board[1][i] + board[2][i] + board[3][i]);
			cnt++;
		}
		
		// Diagonals
		solution[cnt] = (board[1][1] + board[2][2] + board[3][3]);
		cnt++;
		solution[cnt] = (board[1][3] + board[2][2] + board[3][1]);
		
		int winner = 0;
		
		for (int i = 0; i < solution.length; i++)
		{
			String st = solution[i];
			
			if (st.equals("111"))
			{
				winner = 1;
				break;
			}
			else if (st.equals("222"))
			{
				winner = 2;
				break;
			}
		}
		
		ActionscriptObject res = new ActionscriptObject();
		
		// TIE !!!
		if (winner == 0 && moveCount == 9)
		{
			gameStarted = false;
			
			res.put("_cmd", "tie");
			sendResponse(res, currentRoomId, null, getUsersChannels());
			
			endGameResponse = res;
		}
		else if (winner > 0)
		{
			// There is a winner !
			gameStarted = false;
			
			res.put("_cmd", "win");
			res.putNumber("w", winner);

			sendResponse(res, currentRoomId, null, getUsersChannels());
			
			endGameResponse = res;
		}
	}
}
