boolean left,   //物体を右に移動させる
  up,   //物体を下に下げる
  right,   //物体を左に移動させる
  down,   //物体を上に上げる
  rotateright,   //物体を右に回転させる
  rotateleft,   //物体を左に回転させる
  forward,   //物体に近づく
  back,   //物体から遠ざかる
  topspin,   //物体を前回転させる
  backspin,   //物体を下回転させる
  rotate1,rotate2,   //多関節ロボット関節1の回転
  rotate3,rotate4,   //多関節ロボット関節2の回転
  rotate5,rotate6,   //多関節ロボット関節3の回転
  rotate7,rotate8,   //多関節ロボット関節4の回転
  rotate9,rotate10,   //多関節ロボット関節5の回転
  rotate11,rotate12,   //多関節ロボット関節6の回転
  reset,   //カメラ位置・多関節ロボットの姿勢リセット
  test;   //逆運動学解のテスト用
int counter=0;   //カウント用
int i, j, k;   //ループ用
float coordX=0, coordY=0, coordZ=0, rotateA=0, rotateB=0;   //カメラの回転・移動に関わる数値
float rotateC=0,rotateD=0,rotateE=0,rotateF=0,rotateG=0,rotateH=45;   //多関節ロボットの動作に関わる数値
float g=0.2;   //重力加速度
float e=0.9;   //反発係数
float balldiamiter=5;   //ボールの直径
int n=20;   //ボールの数
float [] ballx=new float [n]; float [] bally=new float [n]; float [] ballz=new float [n];   //ボールの位置
float [] speedx=new float [n]; float [] speedy=new float [n]; float [] speedz=new float [n];   //ボールの速度


void setup(){
  size(1600,1200,P3D);
  background(0);
  lights();
  camera(0,0,250,0,0,0,0,1,0);
  for(i=0; i<n; i+=1){   //ボールをランダム配置
    ballx[i]=random(100,200);
    bally[i]=random(-200,-10);
    ballz[i]=random(100,200);
    speedx[i]=random(-1,1);
    speedy[i]=random(-1,1);
    speedz[i]=random(-1,1);
  }
}


void keyPressed() {
  if (keyCode == 37)  left  = true; //←
  if (keyCode == 38)  up  = true; //↑
  if (keyCode == 39)  right  = true; //→
  if (keyCode == 40)  down  = true; //↓
  if (keyCode == 65)  rotateright  = true; //A
  if (keyCode == 68)  rotateleft  = true; //D
  if (keyCode == 69)  forward  = true; //E
  if (keyCode == 81)  back  = true; //Q
  if (keyCode == 83) topspin = true; //S
  if (keyCode == 87) backspin = true; //W
  if (keyCode == 82) rotate1 = true; //R
  if (keyCode == 70) rotate2 = true; //F
  if (keyCode == 84) rotate3 = true; //T
  if (keyCode == 71) rotate4 = true; //G
  if (keyCode == 89) rotate5 = true; //Y
  if (keyCode == 72) rotate6 = true; //H
  if (keyCode == 85) rotate7 = true; //U
  if (keyCode == 74) rotate8 = true; //J
  if (keyCode == 73) rotate9 = true; //I
  if (keyCode == 75) rotate10 = true; //K
  if (keyCode == 79) rotate11 = true; //O
  if (keyCode == 76) rotate12 = true; //L
  if (keyCode == 90) reset = true; //Z
  if (keyCode == 80) test = true; //P
}


void keyReleased() {
  if (keyCode == 37)  left  = false; //←
  if (keyCode == 38)  up  = false; //↑
  if (keyCode == 39)  right  = false; //→
  if (keyCode == 40)  down  = false; //↓
  if (keyCode == 65)  rotateright  = false; //A
  if (keyCode == 68)  rotateleft  = false; //D
  if (keyCode == 69)  forward  = false; //E
  if (keyCode == 81)  back  = false; //Q
  if (keyCode == 83) topspin = false; //S
  if (keyCode == 87) backspin = false; //W
  if (keyCode == 82) rotate1 = false; //R
  if (keyCode == 70) rotate2 = false; //F
  if (keyCode == 84) rotate3 = false; //T
  if (keyCode == 71) rotate4 = false; //G
  if (keyCode == 89) rotate5 = false; //Y
  if (keyCode == 72) rotate6 = false; //H
  if (keyCode == 85) rotate7 = false; //U
  if (keyCode == 74) rotate8 = false; //J
  if (keyCode == 73) rotate9 = false; //I
  if (keyCode == 75) rotate10 = false; //K
  if (keyCode == 79) rotate11 = false; //O
  if (keyCode == 76) rotate12 = false; //L
  if (keyCode == 90) reset = false; //Z
  if (keyCode == 80) test = false; //P
}


void draw(){
  background(0);
  
  float px = cos(radians(rotateC))*sin(radians(rotateD))*100   //多関節ロボット先端のx座標(順運動学用)
    - sin(radians(rotateC))*20
    + cos(radians(rotateC))*sin(radians(rotateD+rotateE))*(35+25)
    + ((cos(radians(rotateC))*cos(radians(rotateD+rotateE))*cos(radians(rotateF))-sin(radians(rotateC))*sin(radians(rotateF)))*sin(radians(rotateG))+cos(radians(rotateC))*sin(radians(rotateD+rotateE))*cos(radians(rotateG)))*20
    + (cos(radians(rotateC))*cos(radians(rotateD+rotateE))*sin(radians(rotateF))+sin(radians(rotateC))*cos(radians(rotateF)))*sqrt(3900)/6
    + ((cos(radians(rotateC))*cos(radians(rotateD+rotateE))*cos(radians(rotateF))-sin(radians(rotateC))*sin(radians(rotateF)))*sin(radians(rotateG+rotateH-45))+cos(radians(rotateC))*sin(radians(rotateD+rotateE))*cos(radians(rotateG+rotateH-45)))*20,
  py = -(10+30)   //多関節ロボット先端のy座標(順運動学用)
    - cos(radians(rotateD))*100
    - cos(radians(rotateD+rotateE))*(35+25)
    + (sin(radians(rotateD+rotateE))*cos(radians(rotateF))*sin(radians(rotateG))-cos(radians(rotateD+rotateE))*cos(radians(rotateG)))*20
    + sin(radians(rotateD+rotateE))*sin(radians(rotateF))*sqrt(3900)/6
    + (sin(radians(rotateD+rotateE))*cos(radians(rotateF))*sin(radians(rotateG+rotateH-45))-cos(radians(rotateD+rotateE))*cos(radians(rotateG+rotateH-45)))*20,
  pz = - sin(radians(rotateC))*sin(radians(rotateD))*100   //多関節ロボット先端のz座標(順運動学用)
    - cos(radians(rotateC))*20
    - sin(radians(rotateC))*sin(radians(rotateD+rotateE))*(35+25)
    - ((sin(radians(rotateC))*cos(radians(rotateD+rotateE))*cos(radians(rotateF))+cos(radians(rotateC))*sin(radians(rotateF)))*sin(radians(rotateG))+sin(radians(rotateC))*sin(radians(rotateD+rotateE))*cos(radians(rotateG)))*20
    + (-sin(radians(rotateC))*cos(radians(rotateD+rotateE))*sin(radians(rotateF))+cos(radians(rotateC))*cos(radians(rotateF)))*sqrt(3900)/6
    - ((sin(radians(rotateC))*cos(radians(rotateD+rotateE))*cos(radians(rotateF))+cos(radians(rotateC))*sin(radians(rotateF)))*sin(radians(rotateG+rotateH-45))+sin(radians(rotateC))*sin(radians(rotateD+rotateE))*cos(radians(rotateG+rotateH-45)))*20;

  float Px = 50, Py = 0, Pz=50;   //多関節ロボット先端の座標(逆運動学用)
  float [] R1 = new float [8]; float [] R2 = new float [4]; float [] R3 = new float [2];
  float l1 = 10, l2 = 30, l3 = 100, l4 = 20, l5 = 35, l6 = 25, l7 = 20, l8 = sqrt(3900)/6, l9 = 20;   //多関節ロボット節の長さ
  float L2 = l8-l4, L4 = l5+l6+l7+l9;   //とする.
  float C3 = (pow(Px,2)+pow(Pz,2)+pow(Py+l1+l2,2)-pow(L2,2)-pow(l3,2)-pow(L4,2))/(2*l3*L4);   //cosθ_3
  float S3_1 = sqrt(1-pow(C3,2)), S3_2 = -sqrt(1-pow(C3,2));   //sinθ_3
  R3[0] = atan(S3_1/C3); R3[1] = atan(S3_2/C3);   //θ_3
  float A = Py+l1+l2, B = sqrt(pow(Px,2)+pow(Pz,2)-pow(L2,2)), M_1 = L4*sin(R3[0]), N_1 = l3+cos(R3[0]), M_2 = L4*sin(R3[1]), N_2 = l3+cos(R3[1]);   //とする.
  R2[0] = atan((M_1*A+N_1*B)/(-N_1*A+M_1*B)); R2[1] = atan((-M_1*A+N_1*B)/(N_1*A+M_1*B)); R2[2] = atan((M_2*A+N_2*B)/(-N_2*A+M_2*B)); R2[3] = atan((-M_2*A+N_2*B)/(N_2*A+M_2*B));   //θ_2
  float X_1 = l3*sin(R2[0])+L4*sin(R2[0]+R3[0]), X_2 = l3*sin(R2[1])+L4*sin(R2[1]+R3[0]), X_3 = l3*sin(R2[2])+L4*sin(R2[2]+R3[0]), X_4 = l3*sin(R2[3])+L4*sin(R2[3]+R3[0]),   //とする.
        X_5 = l3*sin(R2[0])+L4*sin(R2[0]+R3[1]), X_6 = l3*sin(R2[1])+L4*sin(R2[1]+R3[1]), X_7 = l3*sin(R2[2])+L4*sin(R2[2]+R3[1]), X_8 = l3*sin(R2[3])+L4*sin(R2[3]+R3[1]);   //とする.
  R1[0] = atan((L2*Px-X_1*Py)/(X_1*Px+L2*Py)); R1[1] = atan((L2*Px-X_2*Py)/(X_2*Px+L2*Py)); R1[2] = atan((L2*Px-X_3*Py)/(X_3*Px+L2*Py)); R1[3] = atan((L2*Px-X_4*Py)/(X_4*Px+L2*Py));   //θ_1
  R1[4] = atan((L2*Px-X_5*Py)/(X_5*Px+L2*Py)); R1[5] = atan((L2*Px-X_6*Py)/(X_6*Px+L2*Py)); R1[6] = atan((L2*Px-X_7*Py)/(X_7*Px+L2*Py)); R1[7] = atan((L2*Px-X_8*Py)/(X_8*Px+L2*Py));   //θ_1

  /*ーーーーーーーー移動ーーーーーーーー*/
  if(left){
    if(coordX<250){
      coordX+=1.5;
    }
  }
  if(up){
    if(coordY<250){
      coordY+=1.5;
    }
  }
  if(right){
    if(coordX>-250){
      coordX-=1.5;
    }
  }
  if(down){
    if(coordY>-250){
      coordY-=1.5;
    }
  }
  if(rotateright){
      rotateB+=1;
  }
  if(rotateleft){
      rotateB-=1;
  }
  if(forward){
    if(coordZ<160){
      coordZ+=2;
    }
  }
  if(back){
    if(coordZ>-500){
      coordZ-=2;
    }
  }
  if(topspin){
    if(radians(rotateA)<PI/2){
      rotateA+=1;
    }
  }
  if(backspin){
    if(radians(rotateA)>-PI/2){
      rotateA-=1;
    }
  }
  if(rotate1){
    rotateC+=1;
  }
  if(rotate2){
    rotateC-=1;
  }
  if(rotate3){
    if(rotateD<95){
      rotateD+=1;
    }
  }
  if(rotate4){
    if(rotateD>-95){
      rotateD-=1;
    }
  }
  if(rotate5){
    if(rotateE<130){
      rotateE+=1;
    }
  }
  if(rotate6){
    if(rotateE>-130){
      rotateE-=1;
    }
  }
  if(rotate7){
    rotateF+=1;
  }
  if(rotate8){
    rotateF-=1;
  }
  if(rotate9){
    if(rotateG<80){
      rotateG+=1;
    }
  }
  if(rotate10){
    if(rotateG>-80){
      rotateG-=1;
    }
  }
  if(rotate11){
    if(rotateH<45){
      rotateH+=1;
    }
  }
  if(rotate12){
    if(rotateH>0){
      rotateH-=1;
    }
  }
  if(reset){
    rotateA=0; coordX=0; coordY=0; coordZ=0; rotateA=0; rotateB=0; rotateC=0; rotateD=0; rotateE=0; rotateF=0; rotateG=0; rotateH=45;
  }
  if(test){
    counter += 1;
    if(counter % 8 == 0){
      i = 0;
    }
    else if(counter % 8 == 1){
      i = 1;
    }
    else if(counter % 8 == 2){
      i = 2;
    }
    else if(counter % 8 == 3){
      i = 3;
    }
    else if(counter % 8 == 4){
      i = 4;
    }
    else if(counter % 8 == 5){
      i = 5;
    }
    else if(counter % 8 == 6){
      i = 6;
    }
    else{
      i = 7;
    }
    if(counter % 4 == 0){
      j = 0;
    }
    else if(counter % 4 == 1){
      j = 1;
    }
    else if(counter % 4 == 2){
      j = 2;
    }
    else{
      j = 3;
    }
    if(counter % 2 == 0){
      k = 0;
    }
    else{
      k = 1;
    }
    rotateC=degrees(R1[i]);
    rotateD=degrees(R2[j]);
    rotateE=degrees(R3[k]);
  }
  translate(coordX,coordY,coordZ);
  rotateX(radians(rotateA));
  rotateY(radians(rotateB));
  
  /*ーーーーーーーー移動ーーーーーーーー*/
  
  /*ーーーーーーーー軸ーーーーーーーー*/
  pushMatrix();
    float axisweight=(250-coordZ)/500;  //画面の拡大に合わせて軸線の太さを変える
    strokeWeight(axisweight);
    stroke(255,0,0); //赤色X軸
    line(-5000,0,0,5000,0,0);
    stroke(0,255,0); //緑色Y軸
    line(0,-5000,0,0,5000,0);
    stroke(0,0,255); //青色Z軸
    line(0,0,-5000,0,0,5000);
    for(i=-1000; i<=1000; i+=100){
      strokeWeight(axisweight/4);
      stroke(255); //白色XZ平面
      line(-1000,0,i,1000,0,i);
      line(i,0,-1000,i,0,1000);
    }
  popMatrix();
  /*ーーーーーーーー軸ーーーーーーーー*/
    
  /*ーーーーーーーー壁(黄線)ーーーーーーーー*/
  pushMatrix();
    strokeWeight(axisweight);
    stroke(255,255,0);
    noFill();
    rotateX(radians(90));
    rect(-250,-250,500,500);
    rect(-50,-50,100,100);
  popMatrix();
  /*ーーーーーーーー壁(黄線)ーーーーーーーー*/
    
  /*ーーーーーーーー多関節ロボット先端の赤点ーーーーーーーー*/
  pushMatrix();
    translate(px,py,pz);
    fill(255,0,0);
    stroke(255,0,0);
    sphere(1);
  popMatrix();
  /*ーーーーーーーー多関節ロボット先端の赤点ーーーーーーーー*/
    
  /*ーーーーーーーーボールーーーーーーーー*/
  for(i=0; i<n; i+=1){
    //ボールと多関節ロボット先端との接触判定
    int number=0;
    for(j=0; j<n; j+=1){
      if( (ballx[j]==px) && (bally[j]==py) && (ballz[j]==pz) ){
        number+=1;
      }
    }
    if( (sqrt(pow(px-ballx[i],2)+pow(py-bally[i],2)+pow(pz-ballz[i],2))<10) && (rotateH>40) && (number==0) ){
      ballx[i]=px;
      bally[i]=py;
      ballz[i]=pz;
      speedx[i]=0;
      speedy[i]=0;
      speedz[i]=0;
    }
    else{
      //ボールの移動
      speedy[i]+=g;
      ballx[i]+=speedx[i];
      bally[i]+=speedy[i];
      ballz[i]+=speedz[i];
    }
    //地面との衝突判定
    if(bally[i]>-balldiamiter){
      bally[i]=-balldiamiter;
      speedy[i]=-e*speedy[i];
    }
    //外枠との衝突判定
    if(ballx[i]>-balldiamiter+250){
      ballx[i]=-balldiamiter+250;
      speedx[i]=-e*speedx[i];
    }
    if(ballx[i]<balldiamiter-250){
      ballx[i]=balldiamiter-250;
      speedx[i]=-e*speedx[i];
    }
    if(ballz[i]>-balldiamiter+250){
      ballz[i]=-balldiamiter+250;
      speedz[i]=-e*speedz[i];
    }
    if(ballz[i]<balldiamiter-250){
      ballz[i]=balldiamiter-250;
      speedz[i]=-e*speedz[i];
    }
    //内枠との衝突判定
    if((ballx[i]>-balldiamiter-50)&&(ballx[i]<balldiamiter+50)&&(ballz[i]>-balldiamiter-50)&&(ballz[i]<balldiamiter+50)){
      if( ((-50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]>-50) && ((-50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]<50) && (speedz[i]>0) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedz[i]=-e*speedz[i];
      }
      else if( ((speedz[i])*(50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]>-50) && ((speedz[i])*(50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]<50) && (speedx[i]<0) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedx[i]=-e*speedx[i];
      }
      else if( ((50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]>-50) && ((50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]<50) && (speedz[i]<0) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedz[i]=-e*speedz[i];
      }
      else if( ((speedz[i])*(-50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]>-50) && ((speedz[i])*(-50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]<50) && (speedx[i]>0) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedx[i]=-e*speedx[i];
      }
      else if( ((-50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]==50) && ((speedz[i])*(50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]==-50) && (speedx[i]<=0) && (speedz[i]>=0) && (speedx[i]==speedz[i]) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedx[i]=-speedx[i];
        speedz[i]=-speedz[i];
      }
      else if( ((speedz[i])*(50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]==50) && ((50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]==50) && (speedx[i]<=0) && (speedz[i]<=0) && (speedx[i]==speedz[i]) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedx[i]=-speedx[i];
        speedz[i]=-speedz[i];
      }
      else if( ((50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]==-50) && ((speedz[i])*(-50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]==50) && (speedx[i]>=0) && (speedz[i]<=0) && (speedx[i]==speedz[i]) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedx[i]=-speedx[i];
        speedz[i]=-speedz[i];
      }
      else if( ((speedz[i])*(-50-(ballx[i]-speedx[i]))/(speedx[i])+ballz[i]-speedz[i]==-50) && ((-50-(ballz[i]-speedz[i]))*(speedx[i])/(speedz[i])+ballx[i]-speedx[i]==-50) && (speedx[i]>=0) && (speedz[i]>=0) && (speedx[i]==speedz[i]) ){
        ballx[i]-=speedx[i];
        ballz[i]-=speedz[i];
        speedx[i]=-speedx[i];
        speedz[i]=-speedz[i];
      }
    }
    //ボール設置
    pushMatrix();
      fill(255);
      noStroke();
      translate(ballx[i],bally[i],ballz[i]);
      sphere(balldiamiter);
    popMatrix();
  }
  
  float [] storagex=new float [n];   //仮
  float [] storagey=new float [n];   //仮
  float [] storagez=new float [n];   //仮
  //ボール同士の衝突判定
  for(i=0; i<n; i+=1){
    for(j=0; j<n; j+=1){
      if( (sqrt(pow(ballx[i]-ballx[j],2)+pow(bally[i]-bally[j],2)+pow(ballz[i]-ballz[j],2))<=2*balldiamiter) && (i!=j) ){
        ballx[i]-=speedx[i];
        bally[i]-=speedy[i];
        ballz[i]-=speedz[i];
        ballx[j]-=speedx[j];
        bally[j]-=speedy[j];
        ballz[j]-=speedz[j];
        storagex[i]=speedx[i];
        storagey[i]=speedy[i];
        storagez[i]=speedz[i];
        speedx[i]=speedx[j];
        speedy[i]=speedy[j];
        speedz[i]=speedz[j];
        speedx[j]=storagex[i];
        speedy[j]=storagey[i];
        speedz[j]=storagez[i];
      }
    }
  }
  /*ーーーーーーーーボールーーーーーーーー*/
  
  /*ーーーーーーーー多関節ロボットーーーーーーーー*/
  strokeWeight(2);

  //オブジェクト1(地面と固定)
  pushMatrix();
  noFill();
  rotateX(radians(90));
  cylinder(10,100);
  popMatrix();
  
  //関節1の回転
  rotateY(radians(rotateC));
  
  //オブジェクト2
  pushMatrix();
    translate(0,-10,0);
    rotateX(radians(90));
    cylinder(10,80);
  popMatrix();
  pushMatrix();
    fill(255);
    stroke(0);
    translate(0,-40,-20);
    box(30,40,20);
  popMatrix();
  pushMatrix();
    translate(0,-40,20);
    box(30,40,20);
  popMatrix();
  
  //関節2の回転
  translate(0,-40,0);
  rotateZ(radians(rotateD));
  translate(0,40,0);
  
  //オブジェクト3
  pushMatrix();
    translate(0,-90,0);
    box(30,100+20,20);
  popMatrix();
  
  //関節3の回転
  translate(0,-140,0);
  rotateZ(radians(rotateE));
  translate(0,140,0);
  
  //オブジェクト4
  pushMatrix();
    translate(0,-152.5,-20);
    box(30,45,20);
  popMatrix();
  
  //関節4の回転
  translate(0,0,-20);
  rotateY(radians(rotateF));
  translate(0,0,20);
  
  //オブジェクト5
  pushMatrix();
    translate(0,-175,-20);
    rotateX(radians(90));
    cylinder(10,sqrt(1300));
  popMatrix();
  pushMatrix();
    fill(255);
    stroke(0);
    translate(0,-195,-20-sqrt(3900)/6);
    box(sqrt(1300)/2,20,sqrt(3900)/6);
  popMatrix();
  pushMatrix();
    translate(0,-195,-20+sqrt(3900)/6);
    box(sqrt(1300)/2,20,sqrt(3900)/6);
  popMatrix();
  
  //関節5の回転
  translate(0,-200,0);
  rotateZ(radians(rotateG));
  translate(0,200,0);
  
  //オブジェクト6
  pushMatrix();
    translate(0,-210,-20);
    box(sqrt(1300)/2,30,sqrt(3900)/6);
  popMatrix();
  
  //関節6の回転1
  translate(0,-220,0);
  rotateZ(radians(rotateH));
  translate(0,220,0);
  
  //オブジェクト7の1
  pushMatrix();
    translate(-2.5-5*sqrt(2),-220,-10);
    box(15+10*sqrt(2),10,sqrt(3900)/6);
  popMatrix();
  pushMatrix();
    translate(-5-10*sqrt(2),-223-5*sqrt(2),-10);
    box(10,10*sqrt(2)-5,sqrt(3900)/6);
  popMatrix();
  
  //関節6の回転2
  translate(0,-220,0);
  rotateZ(radians(-2*rotateH));
  translate(0,220,0);
  
  //オブジェクト7の2
  pushMatrix();
    translate(2.5+5*sqrt(2),-220,-10);
    box(15+10*sqrt(2),10,sqrt(3900)/6);
  popMatrix();
  pushMatrix();
    translate(5+10*sqrt(2),-223-5*sqrt(2),-10);
    box(10,10*sqrt(2)-5,sqrt(3900)/6);
  popMatrix();
  /*ーーーーーーーー多関節ロボットーーーーーーーー*/
}


void cylinder(float high, float diamiter){
  //円柱(高さ,底面積直径) 基準は底面の中心
  for(i=0; i<20*high; i+=high){
    if((i==0)||(i==19*high)){
      stroke(0);
      ellipse(0,0,diamiter,diamiter);
      stroke(255);
    }
    else{
      ellipse(0,0,diamiter,diamiter);
    }
    for(j=0; j<180; j+=1){
      line(0,0,diamiter/2,0);
      rotateZ(radians(2));
    }
    translate(0,0,high/20);
  }
}
