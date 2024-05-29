import processing.data.JSONObject;
import javax.swing.*;

import processing.core.PApplet;
import processing.data.JSONArray;
import processing.data.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import java.util.Arrays;

JSONObject scoreData;
JSONObject scoreArray;
PImage bgimg;
PImage cats;
PImage plane1;
PImage plane2;
PImage nekocan;
PImage bfstart;
String name;

int scene = 0;
int keyCount = 0;

void setup() {
    size(600,1000);
    bgimg = loadImage("bg.png");
    cats = loadImage("cats.png");
    plane1 = loadImage("plane1.png");
    plane2 = loadImage("plane2.png");
    nekocan = loadImage("nekocan.png");
    bfstart = loadImage("beforestart.png");
}

int y = 0;
int x = 300; 
int bonus = 0;
int block = 1;
int block2 = 0;
int scN = 1;
int scN2 = 2;
int bgb1 = 1;
int bgb2 = 0;
int dy = 10;
int score = 0;
int base_time = 0;

float rdm1 = 0;
float rdm2 = 1;

void draw() {
    switch (scene) {
        case 0:
            common();
            beforestart();
            viewScore();
            break;
        case 1:
            ingame();
            break;
        case 2:
            endgame();
            break;
        case 3:
            logscore();
            break;
        case 4:
            savescore();
            break;
    }
}

void beforestart(){
    image(bfstart,0,0);
    textAlign(CENTER);
}

void ingame(){
    background(#ffffff);
    //カウントダウン
    int time = millis() - base_time;
    dy = (time<=3000) ? 0 : 10;
    //スクロールこれから下
    y = y + dy;
    //bg img
    if(y%2000 == 0 && dy != 0){
        bgb1 = bgb1 + 2;
        image(bgimg,0,y*-1 + 1000*(bgb1));
    }else{
        image(bgimg,0,y*-1 + 1000*(bgb1));
    }
    if(y%2000 == 1000){
        bgb2 = bgb2 + 2;
        image(bgimg,0,y*-1 + 1000*(bgb2));
    }else{
        image(bgimg,0,y*-1 + 1000*(bgb2));
    }
    //bomb
    if(y%2000 == 0 && dy != 0){
        block = block + 2;
        scN = floor(random(4))+1;
        rdm1 = random(100);
        screen(y, block, scN, x, rdm1);
    }else{
        screen(y, block, scN, x, rdm1);
    }
    if(y%2000 == 1000){
        block2 = block2 + 2;
        scN2 = floor(random(4))+1;
        rdm2 = random(100);
        screen(y, block2, scN2, x, rdm2);
    }else if(y > 1000){
        screen(y, block2, scN2, x, rdm2);
    }
    //people
    if(dy <= 5){
        textSize(150);
        textAlign(CENTER);
        fill(#000000);
        text((3-floor(time/1000)),width/2,height/2);
    }else{
        people(x);
    }
}

void endgame(){
    image(bgimg,0,0);
    textAlign(CENTER);
    fill(#000000);
    textSize(70);
    text("Your Score:"+score, width/2,height/2);
    textSize(40);
    text("End game -> press space", width/2,height/2+50);
    text("Save Score -> press Enter", width/2, height/2+100);
}

void logscore(){
    fill(#000000);
    textAlign(CENTER);
    if(keyPressed && keyCount == 0){
        if(key == BACKSPACE){
            if(name.length()>0){
                name = name.substring(0,name.length()-1);
            }
            keyCount = 1;
        }else if(key == ENTER){
            
        }else if(keyCode == 0){
            name = name + key;
            keyCount = 1;
        }else if(keyCount == 2){
            name = str(key);
            keyCount = 1;
        }
    }
    image(bgimg,0,0);
    text("Your name",width/2,height/2-80);
    text(name,width/2,height/2-40);
    text("Your score",width/2,height/2);
    text(score,width/2,height/2+40);
    rect(width/2-100,height/2+55,200,30);
    fill(#ff3333);
    text("save score",width/2,height/2+80);
    if(mouseX >= width/2 - 100 && mouseX <= width/2 + 100 && mouseY >= height/2 + 55 && mouseY <= height/2 + 85 && mousePressed == true && name.length() != 0){
        scene = 0;
        print("click");
        
        JSONObject scoreData;
        JSONArray scoreArray;
        JSONObject loadedData = loadJSONObject("score.json");
        if (loadedData != null) {
            scoreData = loadedData;
            scoreArray = scoreData.getJSONArray("scores");
            if (scoreArray == null) {
                scoreArray = new JSONArray();
            }
        } else {
            scoreData = new JSONObject();
            scoreArray = new JSONArray();
        }

        JSONObject newScore = new JSONObject();
        newScore.setInt("score", score);
        newScore.setString("name", name);
        scoreArray.append(newScore);

        scoreData.setJSONArray("scores", scoreArray);
        saveJSONObject(scoreData, "score.json");

        print("saved");
    }
}

void savescore(){
    image(bgimg,0,0);
}

void common(){
    y = 0;
    x = 300;
    bonus = 0;
    block = 1;
    block2 = 0;
    scN = 1;
    scN2 = 2;
    bgb1 = 1;
    bgb2 = 0;
    dy = 10;
    score = 0;
    base_time = 0;
}

void people(float x) {
    fill(#00ff00);
    image(cats,x-30,270,60,60);
}

void screen(int y, int block, int screenN, float x, float rdm){
    String scrN = "screen" + screenN;
    JSONObject json = loadJSONObject("json1/box.json");
    JSONArray screens = json.getJSONArray(scrN);
    for (int i = 0; i < screens.size(); ++i) {
        JSONObject screen = screens.getJSONObject(i);
        int dx = screen.getInt("x");
        int dy = screen.getInt("y");
        int bn = screen.getInt("obj");
        float rdms = (rdm+sq(bn))/bn%10;
        boolean bonusTF = screen.getBoolean("TF");
        int objy = y*-1 + height*block + dy;
        score = y + bonus;
        textAlign(RIGHT);
        textSize(40);
        fill(#000000);
        text("score:"+score,(width - 30),30);
        if(bonusTF == true){
            image(nekocan,dx-35,objy-35,70,70);
        }else if(rdms < 5){
            image(plane1,dx-30,objy-30,60,60);
        }else{
            image(plane2,dx-30,objy-30,60,60);
        }

        if(dist(x,300,dx,objy)<50){
            if(bonusTF == true){
                if(objy == 300){
                    bonus = bonus + screen.getInt("pts");
                    objy = objy - 2000;
                }
            }else if(bonusTF == false){
                scene = 2;
                break;
            }
        }
    }
}

void viewScore(){
    JSONObject scoreBoard = loadJSONObject("score.json");
    JSONArray scores = scoreBoard.getJSONArray("scores");

    Score[] scoreArray = new Score[scores.size()];
    for (int j = 0; j < scores.size(); j++){
        JSONObject scoreObj = scores.getJSONObject(j);
        int scoreValue = scoreObj.getInt("score");
        String scoreName = scoreObj.getString("name");
        scoreArray[j] = new Score(scoreValue, scoreName);
    }

    sortByScore(scoreArray);

    fill(#000000);
    textSize(30);
    textAlign(LEFT);
    text("TOP5 scores",20,40);
    for (int j = 0; j < min(scores.size(),5); j++){
        text(scoreArray[j].scoreV,30,75 + 30*j);
        text(scoreArray[j].nameV,210,75 + 30*j);
    }
}

class Score {
    int scoreV;
    String nameV;

    Score(int s, String n){
        scoreV = s;
        nameV = n;
    }
}

void sortByScore(Score[] arr){
    Arrays.sort(arr, (a,b) -> b.scoreV - a.scoreV);
}

void keyPressed() {
    if(key == ' ') {
        if(scene == 0){
            scene = 1;
            base_time = millis();
        }else if(scene == 2 || scene == 4){
            scene = 0;
        }
    }else if(key == ENTER){
        if(scene == 2){
            scene = 3;
            name = "";
            keyCount = 2;
            image(bgimg,0,0);
        }
    }else if(key == CODED){
        if(keyCode == RIGHT && x < 600){
            x = x + 10;
        }else if(keyCode == LEFT && x > 0){
            x = x - 10;
        }
    }
}

void keyReleased() {
    if(scene == 3){
        keyCount = 0;
    }
}