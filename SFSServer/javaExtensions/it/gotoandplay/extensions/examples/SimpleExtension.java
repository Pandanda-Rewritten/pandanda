package it.gotoandplay.extensions.examples;

import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.extensions.ExtensionHelper;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

/**
 * <p>
 * This is the most simple <b>SmartFoxServer</b> extension possible.<br>
 * In a nutshell, every extension has to accomplish four different tasks:<br>
 * 
 * <ul>
 * <li>Initialize</li>
 * <li>Handle client requests</li>
 * <li>Handle events dispatched by the Server</li>
 * <li>Destroy and release its resources</li>
 * </ul>
 * 
 * <br>
 * Extensions must implement the following methods:
 * 
 * <ul>
 * 	<li><b>init()</b> - here goes all your custom initialization code</li>
 * 	<li><b>destroy()</b> - this is invoked by the Server before shutting down the extension. Here you should release all the resources (close files, stop Timers and Threads etc...) that the extension uses</li>
 * 	<li><b>handleRequest()</b> - handles requests coming from the client</li>
 * 	<li><b>handleInternalEvent()</b> - handles the events dispatched by the Server</li>
 * </ul>
 * </p>
 * 
 * 
 * @author Marco
 *
 */
public class SimpleExtension extends AbstractExtension
{
	private ExtensionHelper helper;
	
	/**
	 * Initialize the extension.<br>
	 * It's always good practice to keep a reference to the ExtensionHelper object
	 */
	public void init()
	{
		helper = ExtensionHelper.instance();
		
		// Traces the message to the AdminTool and to the console
		trace("Hi! The Simple Extension is initializing");
	}
	
	/**
	 * Destroy the extension
	 */
	public void destroy()
	{
		trace("Bye bye! SimpleExtension is shutting down!");
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
		trace("The command -> " + cmd + " was invoked by user -> " + u.getName());
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
		trace("Received a server event --> " + ieo.getEventName());
	}

}
