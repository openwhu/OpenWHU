package server;

import java.awt.Graphics;
import java.awt.Image;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import javax.swing.ImageIcon;
import javax.swing.JFrame;
import javax.swing.JPanel;




public class VideoPlayer {
	public static volatile int curIndex=0;
	public static volatile int receiveState=0;//0无需接收;1需要接收,2正在接收
	
	public static Image image=new ImageIcon("ReceiveCache0/screenShot0.jpg").getImage();
	
	public static SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	public static void play() {
		JFrame playerJF=new JFrame("Neptune");
		playerJF.setSize(960,540);
		playerJF.setLayout(null);
		playerJF.setLocationRelativeTo(null);
		MyDrawPanel showPhoto=new MyDrawPanel();
		showPhoto.setBounds(90, 30, 960, 540);
		playerJF.add(showPhoto);
		playerJF.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		//playerJF.repaint();
		playerJF.setVisible(true);
		//playerJF.repaint();
		
		 Timer timer=new Timer();
		timer.schedule(new TimerTask() {
			@Override
			public void run() {
				// TODO 自动生成的方法存根
				playerJF.repaint();
				curIndex++;
				if(curIndex==101) {
					curIndex=0;
					GlobalVarServerRepo.playerRepoNum=(GlobalVarServerRepo.playerRepoNum+1)%3;
					GlobalVarServerRepo.storeRepoNum=(GlobalVarServerRepo.storeRepoNum+1)%3;
					receiveState=1;
				}
			}
		},0,200);
		
		Timer timer2=new Timer();
		timer2.schedule(new TimerTask() {
			@Override
			public void run() {
				// TODO 自动生成的方法存根
				if(receiveState==1) {
					receiveState=2;
					System.out.println("[Log]:"+df.format(new Date())+" Receive in repo "+GlobalVarServerRepo.storeRepoNum);
					Receiver.receive(GlobalVarServerRepo.storeRepoNum);
					receiveState=0;
				}else {
					System.out.println("[Log]: Thread give up");
				}
			}
		},0,400);
		
	}
	
	static class MyDrawPanel extends JPanel {
	    public void paintComponent(Graphics g){
	    	image.flush();
	    	image=new ImageIcon(
	    			GlobalVarServerRepo.repoFolderStr+String.valueOf(GlobalVarServerRepo.playerRepoNum)
	    			+GlobalVarServerRepo.screenShotPrefixStr
	    			+String.valueOf(curIndex)+"."+GlobalVarServerRepo.screenShotTypeStr).getImage();
	        
	    	
	    	//Image myimage=new ImageIcon("ReceiveCache0/screenShot0.jpg").getImage();
	    	g.drawImage(image,0,0,this);
	    }
	}
	public static void main(String[]args) {
		play();
	}
}


