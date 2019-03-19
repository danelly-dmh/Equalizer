/*
Adrian Eduardo Barrios Lopez 
13550350
Graficación
Proyecto: Botones con imagen
8/Mayo/2016
*/

import controlP5.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
//import processing.sound.*;

//SoundFile file;
ControlP5 selection;
ControlP5 ui;
ControlP5 ui2;
ControlP5 ui3;
ControlP5 mut;
ControlP5 cbars;
ControlP5 cbar;
ControlP5 cbar2;
ControlP5 cp5;
Minim minim;
AudioPlayer song;
AudioMetaData meta;
HighPassSP highpass;
LowPassSP lowpass;
BandPass bandpass;
FFT fft;
int duration = 10;
int timeback = 0;
int millis = 0;
int Progress = 0;
int Volume = 0;
int Hpass;
int Lpass;
int Bpass;
float Vol = 0;
int seg = 0;
int min = 0;
float freq;
boolean selec;
PImage img_mute;
PImage img_unmute;

void setup(){
 size(700, 400);
 minim = new Minim(this);
 //song = minim.loadFile("Trance_-_009_Sound_System_Dreamscape.mp3", 1024);
 //duration = song.length();
 
 selection = new ControlP5(this);
 selection.addButton("selections")
 .setPosition(5,height-31)
 .setSize(45,20);
 
 img_mute = loadImage("mute.png");
 img_unmute = loadImage("unmute.png");
 mut = new ControlP5(this);
 mut.addButton("mute")
 .setValue(0)
 .setPosition(532,height-36)
 .setSize(20,20)
 .setImage(img_unmute)
 .updateSize();
 
 cbars = new ControlP5(this);
 cbars.addSlider("Progress")
 .setPosition(165,height-30)
 .setRange(0,duration)
 .setSize(350,15);
 
 cbars.getController("Progress").setValueLabel("");
 cbars.getController("Progress").setCaptionLabel("");
  
 cbar2 = new ControlP5(this);
 cbar2.addSlider("Volume")
     .setPosition(560,height-29)
     .setSize(110,12)
     .setRange(-30,30)
     .setValue(0)
     .setNumberOfTickMarks(21);
   
 cbar2.getController("Volume").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingY(100);
 cbar2.getController("Volume").getCaptionLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(-28).setPaddingY(5);
 //cbar2.getController("Volume").getCaptionLabel().align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(25).setPaddingY(5);
 
 cp5 = new ControlP5(this);
 cp5.addSlider("Hpass")
     .setPosition(550,230)
     .setSize(20,100)
     .setRange(0,3000)
     .setValue(0)
     .setNumberOfTickMarks(30);
     
 cp5.addSlider("Lpass")
     .setPosition(650,230)
     .setSize(20,100)
     .setRange(3000,20000)
     .setValue(3000)
     .setNumberOfTickMarks(30);
     
 cp5.addSlider("Bpass")
     .setPosition(600,230)
     .setSize(20,100)
     .setRange(100,1000)
     .setValue(100)
     .setNumberOfTickMarks(30);
     
 cp5.getController("Hpass").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingY(100);
 cp5.getController("Lpass").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingY(100);
 cp5.getController("Bpass").getValueLabel().align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingY(100);
     
 ui = new ControlP5(this);
 PImage[] imgs_a = {loadImage("button_play1.png"),loadImage("button_play2.png"),loadImage("button_play3.png")};
 ui.addButton("play").setValue(0).setPosition(90,height-40).setSize(10,10).setImages(imgs_a).updateSize();
 ui2 = new ControlP5(this);
 PImage[] imgs_b = {loadImage("button_pause1.png"),loadImage("button_pause2.png"),loadImage("button_pause3.png")};
 ui2.addButton("pause").setValue(0).setPosition(126,height-40).setSize(10,10).setImages(imgs_b).updateSize();
 ui3 = new ControlP5(this);
 PImage[] imgs_c = {loadImage("button_stop1.png"),loadImage("button_stop2.png"),loadImage("button_stop3.png")};
 ui3.addButton("stops").setValue(0).setPosition(54,height-40).setSize(10,10).setImages(imgs_c).updateSize();
 /*
 file = new SoundFile(this, "[I'm_Blue_-_(da_ba_dee).mp3");
 println("SFSampleRate = " + file.sampleRate() + " Hz");
 println("SFSample = " + file.frames() + " samples ");
 println("SFSample = " + file.duration() + " samples ");
 */
}

public void draw(){
  background(0);
  fill(150);
  noStroke();
  rect(0,350,width,height);
  rect(517,0,width-515,height);
  fill(255);
  stroke(0);
  text("Title: ", 525, 15);
  text("Author: ", 525, 30);
  text("Duration: ", 525, 45);
  if(selec){
  if(mousePressed && mouseX>165 && mouseX<515 && mouseY>370 && mouseY<385){
    if(song.isPlaying() == true){
      song.pause();
      song.play(Progress);
    } else {
      song.cue(Progress);
      millis = Progress;
    }
  }
  if(mousePressed && mouseX>560 && mouseX<670 && mouseY>371 && mouseY<383){
    song.setGain(Volume);
    if(Volume == -30){
      song.mute();
      mut.getController("mute").setImage(img_mute);
    } else {
      song.unmute();
      mut.getController("mute").setImage(img_unmute);
    }
  }
  cbar.getController("Progress").setValue(song.position());
  if(song.position() == duration){
    stops();
  }
  seg = song.position()/1000%60;
  min = song.position()/(60*1000)%60;
  String se = nf(seg, 2);
  String mi = nf(min, 2);
  text(mi+":"+se, 165, height-3); 
  int segd = duration/1000%60;
  int mind = duration/(60*1000)%60;
  String sed = nf(segd, 2);
  String mid = nf(mind, 2);
  text("Duration: "+mid+":"+sed, 525, 45);
  millis = song.position();
  
  timeback = duration - song.position();
  int segres = timeback/1000%60;
  int minres = timeback/(60*1000)%60;
  String sedres = nf(segres, 2);
  String midres = nf(minres, 2);
  text("- "+midres+":"+sedres, 470, height-3);
  //
  textSize(12);
  text("Title: " + meta.title(), 525, 15);
  text("Author: " + meta.author(), 525, 30);
  /*text("File Name: " + meta.fileName(), 5, y);
  text("Length (in milliseconds): " + meta.length(), 5, y+=yi);
  text("Title: " + meta.title(), 5, y+=yi);
  text("Author: " + meta.author(), 5, y+=yi); 
  text("Album: " + meta.album(), 5, y+=yi);
  text("Date: " + meta.date(), 5, y+=yi);
  text("Comment: " + meta.comment(), 5, y+=yi);
  text("Track: " + meta.track(), 5, y+=yi);
  text("Genre: " + meta.genre(), 5, y+=yi);
  text("Copyright: " + meta.copyright(), 5, y+=yi);
  text("Disc: " + meta.disc(), 5, y+=yi);
  text("Composer: " + meta.composer(), 5, y+=yi);
  text("Orchestra: " + meta.orchestra(), 5, y+=yi);
  text("Publisher: " + meta.publisher(), 5, y+=yi);
  text("Encoded: " + meta.encoded(), 5, y+=yi);*/
  if(Volume == -30){
      song.mute();
      mut.getController("mute").setImage(img_mute);
    } else {
      song.unmute();
      mut.getController("mute").setImage(img_unmute);
    }
    
    highpass.setFreq(Hpass);
    lowpass.setFreq(Lpass);
    bandpass.setFreq(Bpass);
    
    fill(0);
    stroke(255);
    fft.forward(song.mix);
    for(int i = 0; i < fft.specSize(); i++){
    float band = fft.getBand(i);
    float vo = 350 - band*50;
    line(i, 350, i, vo);
    }
  }
}

public void selections(){
 selec = false;
 selectInput("Select a file to process:", "fileSelected");
}

public void play(){
 //file.play();
 song.play(millis);
}

public void pause(){
 //file.play();
 song.pause();
 millis = song.position();
}

public void stops(){
 //song.stop();
 song.pause();
 millis = 0;
 song.cue(0);
}

public void mute(){
  if(song.isMuted() == true){
    //slider
    cbar2.getController("Volume").setValue(Vol);
    //gaing
    song.setGain(Volume);
    song.unmute();
    mut.getController("mute").setImage(img_unmute);
  } else {
    Vol = song.getGain();
    cbar2.getController("Volume").setValue(-30);
    song.setGain(Volume);
    song.mute();
    mut.getController("mute").setImage(img_mute);
  }
}

void fileSelected(File selection){
 if(selection != null){
   minim.stop();
   song = minim.loadFile(selection.getAbsolutePath(), 1024);
   meta = song.getMetaData();
   fft = new FFT(song.bufferSize(), song.sampleRate());
   highpass = new HighPassSP(300, song.sampleRate());
   song.addEffect(highpass);
   lowpass = new LowPassSP(300, song.sampleRate());
   song.addEffect(lowpass);
   bandpass = new BandPass(300, 300, song.sampleRate());
   song.addEffect(bandpass);
   duration = song.length();
   
   cbar = new ControlP5(this);
   cbar.addSlider("Progress")
   .setPosition(165,height-30)
   .setRange(0,duration)
   .setSize(350,15);
   
   cbar.getController("Progress").getValueLabel()
   .align(ControlP5.LEFT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setPaddingY(30);
   cbar.getController("Progress").getCaptionLabel()
   .align(ControlP5.RIGHT, ControlP5.BOTTOM_OUTSIDE).setPaddingX(0).setPaddingY(30);
   
   selec = true;
   
 } else {
   selec = false;
   if(song != null){
     selec = true;
   }
   println("Window was closed or the user hit cancel. "); 
 }
}
//public void controlEvent(ControlEvent event){
 //println(event.getController().getName()); 
//}