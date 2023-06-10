using Godot;
using System;
using Rug.Osc.Core;
using System.Net;

public partial class OSCReceiveHandler : Node
{
  static OscReceiver receiver;

  [Export]
  private string[] oscMessages;
  //OSC port to listen on:
  [Export]
  public int port;


    [Signal]
    public delegate void E1_OnEventHandler(float millisecs);

    [Signal]
    public delegate void E1_OffEventHandler();

    [Signal]
    public delegate void E2_OnEventHandler();

    [Signal]
    public delegate void E2_OffEventHandler();

[Signal]
    public delegate void OSCGeneralEventHandler(string messageName);

  private string[] msgNames;

	 public override void _Ready()
    {
        
        GD.Print("OSC Booting");

        // Create the receiver
        receiver = new OscReceiver(port);

        if (receiver.State == OscSocketState.Connected)
        {
            receiver.Close();
            GD.Print("socket closed");
        }
        // Connect the receiver
        receiver.Connect();

    }

	public override void _PhysicsProcess(double delta)
    {
        if (receiver.State != OscSocketState.Closed)
        {  
                // if we are in a state to recieve
                if (receiver.State == OscSocketState.Connected)
                {
                  if(receiver.TryReceive(out OscPacket msg))
                  {
					// for loop iterates through all messages coming in, based on number of msgs specified by the user
                    for(int i = 0; i < oscMessages.Length; i++)
                    {
                    OscPacket packet = msg;
                    string mess = packet.ToString();
                    string[] messArray = mess.Split(",");

                    if(messArray[0] == oscMessages[i])
                    {
                        if(messArray[1].ToFloat() >0)
                        {
                            EmitSignal(SignalName.OSCGeneral, oscMessages[i]);
                        }
                        
                        if(messArray[1].ToFloat() > 0)
                        {
                            //GD.Print(oscMessages[i] + "on");
                            if(i == 0)
                            {
                                EmitSignal(SignalName.E1_On, messArray[1].ToFloat());
                            }
                            else if (i == 1)
                            {
                                EmitSignal(SignalName.E2_On);
                            }
                        }
                        else if(messArray[1].ToInt() == 0)
                        {
                        	//GD.Print(oscMessages[i] + "off");
                            if(i == 0)
                            {
                                EmitSignal(SignalName.E1_Off);
                            }
                            else if (i == 1)
                            {
                                EmitSignal(SignalName.E2_Off);
                            }
                        }
                    }
                    }
                  }

                    // Write the packet to the console 
                    //GD.Print(packet.ToString());
                    // close the Receiver
                }
            
        }
    }
}
