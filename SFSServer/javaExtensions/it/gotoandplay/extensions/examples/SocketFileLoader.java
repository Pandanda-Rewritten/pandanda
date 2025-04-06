package it.gotoandplay.extensions.examples;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.LinkedList;

import it.gotoandplay.smartfoxserver.data.User;
import it.gotoandplay.smartfoxserver.events.InternalEventObject;
import it.gotoandplay.smartfoxserver.extensions.AbstractExtension;
import it.gotoandplay.smartfoxserver.lib.ActionscriptObject;

/**
 * SocketFileLoader Extension Example
 * version 1.0.0
 * @author Lapo
 * 
 * July 2007 (c) gotoAndPlay()
 * 
 * -------------------------------------------------------------------------
 * 
 * This extension demonstrates how you can easily transmit binary data
 * (i.e. image or swf files, zipped / encrypted data) to the client.
 * 
 * With the new ByteArray class in Flash CS3 / Flex 2 you can dynamically load
 * assests and binary data directly from the socket server, without leaving any track
 * in the browser's cache.
 *
 */
public class SocketFileLoader extends AbstractExtension
{
	// Path to the image folder
	private String path = "javaExtensions/it/gotoandplay/extensions/examples/images/";
	
	/**
	 * Initialize extension
	 */
	public void init()
	{
		trace("Socket File Loader -- Started!");
	}
	
	/**
	 * Shut down extension
	 */
	public void destroy()
	{
		trace("Socket File Loader -- Stopped!");
	}
	
	/**
	 * Handle a String based request
	 */
	public void handleRequest(String cmd, String[] params, User who, int roomId) 
	{
		if (cmd.equals("loadImg"))
		{
			// Get the id of the image to load
			int id = Integer.parseInt(params[0]);
			

			// Respone array
			String[] response = new String[3];
			
			try
            {
				response[0] = "loadImg";
				
				// endcode data
                String encodedData = encodeFile(path + "image_" + id + ".jpg");
                
                // success!
                response[1] = "1";
                
                // file data
                response[2] = encodedData;
                
            }
            catch (IOException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
                
                // failure
                response[1] = "0";
                
                // empty data
                response[2] = "";
            }
				
            LinkedList recipients = new LinkedList();
            recipients.add(who.getChannel());
            
            sendResponse(response, -1, null, recipients);
		
		}
	}
	
	public void handleRequest(String cmd, ActionscriptObject aObj, User who, int roomId) 
	{
		// nothing to do here
	}
	
	public void handleInternalEvent(InternalEventObject ieo)
	{
		// nothing to handle here
	}
	
	/**
	 * Loads a file and encodes into Base64
	 * 
	 * @param filePath		the path of the file
	 * @return				the Base64 encoded file
	 * @throws IOException	
	 */
	private String encodeFile(String filePath) throws IOException
	{
		String encodedData;
		
		File input = new File(filePath);
		
		// Prepare byte array according to the file size
		byte[] byteData = new byte[(int) input.length()];
		
		// Read data from file into byte array
		FileInputStream inStream = new FileInputStream(input);
		inStream.read(byteData);
	
		// Encode in Base64
		encodedData = Base64.encodeBytes(byteData, Base64.DONT_BREAK_LINES);
		
		return encodedData;
	}
}
