package server;

import java.awt.Font;

import javax.swing.JFrame;
import javax.swing.JLabel;

public class WaitingTip {
	public static JFrame jf=new JFrame("wait");
	public  JLabel waitTipLabel=new JLabel("Wait image caching....",JLabel.CENTER);
	public void show() {
		jf.setSize(300,200);
		jf.setLayout(null);
		jf.setLocationRelativeTo(null);
		waitTipLabel.setFont(new Font("Segoe UI", Font.PLAIN, 16));
		waitTipLabel.setSize(300, 150);
		jf.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		jf.add(waitTipLabel);
		jf.setVisible(true);
	}
	public static void main(String[]args) {
		WaitingTip testTip=new WaitingTip();
		testTip.show();
	}
}
