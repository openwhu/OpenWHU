package client;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.OutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class Sender {
	public static ServerSocket ss=null;
	/**
	 * 开启监听
	 * */
	public static void startListenPort(){
        try{
            ss = new ServerSocket(GlobalVarClientRepo.port);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
	/**
	 * void send()
	 * 每调用一次在指定端口发送0-100共101张图
	 * 必须先调用startListenPort()开启监听
	 * */
	public static void send() {
		int curIndex=0;
		while(curIndex<=GlobalVarClientRepo.MaxCaptureIndex) {
			Socket sender=null;
            OutputStream outWriter=null;
            FileInputStream fileReader=null;
            try {
            	sender=ss.accept();
            	 outWriter=new DataOutputStream(sender.getOutputStream());
                 File targetFile=new File(GlobalVarClientRepo.repoFolderStr+GlobalVarClientRepo.screenShotPrefixStr
                		 +String.valueOf(curIndex)+"."+GlobalVarClientRepo.screenShotTypeStr);
                
                 byte[]data=new byte[(int)targetFile.length()];
                 fileReader=new FileInputStream(targetFile);
                 fileReader.read(data);
                 outWriter.write(data);
                 
                 sender.shutdownOutput();
            }catch (Exception e) {
				// TODO: handle exception
            	e.printStackTrace();
            }
            try {
            	fileReader.close();
            	outWriter.close();
            	sender.close();
            }catch (Exception e) {
				// TODO: handle exception
            	e.printStackTrace();
            }
            
            curIndex++;
		}
	}
}
