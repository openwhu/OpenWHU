package server;

import java.awt.BorderLayout;
import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;
import javax.swing.JLabel;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JTextField;
import javax.swing.SwingWorker;
import javax.swing.JButton;

public class ServerGUI extends JFrame {

	private JPanel contentPane;
	private JTextField ipTextField;
	
	private static volatile boolean firstFinished=false;

	/**
	 * Launch the application.
	 */
	public static void main(String[] args) {
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				try {
					ServerGUI frame = new ServerGUI();
					frame.setVisible(true);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		});
	}

	/**
	 * Create the frame.
	 */
	public ServerGUI() {
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		setSize(600,400);
		setLocationRelativeTo(null);
		contentPane = new JPanel();
		contentPane.setBorder(new EmptyBorder(5, 5, 5, 5));
		setContentPane(contentPane);
		contentPane.setLayout(null);
		
		JLabel titleLabel = new JLabel("Screen Monior");
		titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 21));
		titleLabel.setBounds(219, 28, 149, 46);
		contentPane.add(titleLabel);
		
		ipTextField = new JTextField();
		ipTextField.setBounds(49, 169, 175, 27);
		contentPane.add(ipTextField);
		ipTextField.setColumns(10);
		
		JLabel ipTipLabel = new JLabel("Please input target IP");
		ipTipLabel.setFont(new Font("Segoe UI", Font.PLAIN, 16));
		ipTipLabel.setBounds(49, 137, 175, 22);
		contentPane.add(ipTipLabel);
		
		JButton startButton = new JButton("Start!");
		startButton.setFont(new Font("Segoe UI", Font.PLAIN, 16));
		startButton.setBounds(236, 276, 104, 31);
		contentPane.add(startButton);
		
		startButton.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent e) {
				Receiver.check();
				// TODO 自动生成的方法存根
				String ipString=ipTextField.getText();
				GlobalVarServerRepo.clientIP=ipString;
				System.out.println("Now you are trying to connect to "+GlobalVarServerRepo.clientIP);
				/*
				TipFrame tipFrame=new TipFrame();
				tipFrame.setPriority(Thread.MAX_PRIORITY);
				tipFrame.start();
				*/
				WaitingTip waiTip=new WaitingTip();
				waiTip.show();
				new SwingWorker<Void, Void>() {  
			        @Override  
			        protected Void doInBackground() {  
			        	Receiver.receive(0);
						Receiver.receive(1);
						firstFinished=true;
			        	return null;
			        }  
			        @Override  
			        protected void done() {  
			            waiTip.jf.dispose();
			            GlobalVarServerRepo.storeRepoNum=1;
						VideoPlayer.play();
			        }  
			    }.execute();  
			    
				
				/*
				FirstReceive firstReceive=new FirstReceive(ipString);
				firstReceive.start();
				while(!firstFinished) {
					try {
						Thread.sleep(500);
					}catch (Exception exception) {
						// TODO: handle exception
						exception.printStackTrace();
					}
				}
				WaitingTip.jf.dispose();
				
				*/
			}
		});
	}
	
	/*
	class TipFrame extends Thread{
		public void run() {
			WaitingTip waiTip=new WaitingTip();
			waiTip.show();
		}
	}
	class FirstReceive extends Thread{
		String ipString;
		public FirstReceive(String ipString) {
			this.ipString=ipString;
		}
		public void run() {
			Receiver.receive(0);
			Receiver.receive(1);
			firstFinished=true;
		}
	}
	*/
}


