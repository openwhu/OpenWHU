package client;

import java.awt.AWTException;
import java.awt.Image;
import java.awt.MenuItem;
import java.awt.PopupMenu;
import java.awt.SystemTray;
import java.awt.Toolkit;
import java.awt.TrayIcon;
import java.awt.event.ActionListener;
import java.io.File;

import java.awt.event.ActionEvent;

import javax.swing.JOptionPane;


public class ClientGUI {
	private static final String logoPath="resource/logo.jpg";
	public static void start() {
		int choose= JOptionPane.showConfirmDialog(
                null,"Would you want to start Screen Monitor?\n","Tip",JOptionPane.YES_NO_OPTION);
        if(choose==JOptionPane.YES_OPTION){
            JOptionPane.showMessageDialog(
            		null,"Start Screen Monitor","Tip",JOptionPane.INFORMATION_MESSAGE);
            trayStart();
            
            check();
            Sender.startListenPort();
            
            while(true) {
            	Screen.capture();
            	Sender.send();
            }
            
        }else{
            JOptionPane.showMessageDialog(null,"You have refused\nThe program will exit","Tip",JOptionPane.INFORMATION_MESSAGE);
        }
	}
	public static void trayStart(){
        if(SystemTray.isSupported()){
            TrayIcon trayIcon = null;
            Image programLogo= Toolkit.getDefaultToolkit().getImage(logoPath);
            SystemTray tray = SystemTray.getSystemTray();
            
            ActionListener listener = new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                	WorkingStateTipFrame frame = new WorkingStateTipFrame();
					frame.setVisible(true);
                }
            };

            // 创建弹出菜单
            PopupMenu popup = new PopupMenu();
            // 主界面选项
            MenuItem mainFrameItem = new MenuItem("Main Frame");
            mainFrameItem.addActionListener(listener);
            // 退出程序选项
            MenuItem exitItem = new MenuItem("exit");
            exitItem.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    if (JOptionPane.showConfirmDialog(null, "Exit program after 3s?") == 0) {
                        try{
                            Thread.sleep(3000);
                        }catch (Exception exception){
                            exception.printStackTrace();
                        }
                        System.exit(0);
                    }
                }
            });
            popup.add(mainFrameItem);
            popup.add(exitItem);
            trayIcon = new TrayIcon(programLogo, "Monitor", popup);// 创建trayIcon
            trayIcon.addActionListener(listener);
            try {
                tray.add(trayIcon);
            } catch (AWTException e1) {
                e1.printStackTrace();
            }

        }else{
            JOptionPane.showMessageDialog(
                    null,"You OS is not supported Tray\n The program will exit","Error",JOptionPane.ERROR_MESSAGE);
        }
    }
	
	
	public static void check() {
		File repoFolder=new File(GlobalVarClientRepo.repoFolderStr);
        if(repoFolder.exists()) {
     	   if(repoFolder.isDirectory()) {
     		   System.out.println("[Log]: repo is normal");
     	   }else {
     		   System.out.println("[Log]: repo is occupied by a file");
     		   repoFolder.delete();
     		   System.out.println("[Log]: delete file and try create folder");
     		   repoFolder.mkdir();
     	   }
     	   
        }else {
        	System.out.println("[Log]: repo is not exist, try to create folder");
     	   	repoFolder.mkdir();
        }
	}
	
	public static void main(String[]args) {
		start();
	}
	
}
