PVector pinchPosition = new PVector(0.0f, 0.0f);
PVector pinchOrigin = new PVector(0.0f, 0.0f);
PVector targetPosition = new PVector(0.0f, 0.0f);
PVector relative = new PVector(0.0f, 0.0f);
 
 
 
 
 void setup(){
   
   size(displayWidth, displayHeight);
   
 }
 
 void draw(){
   
   background(255);
   
   update();
   render();
   
 }
 
 //城の位置を更新
void keyPressed(){
   
    switch(key){
    
      case 'w':
      targetPosition = new PVector(0.0f, 0.0f);
      break;
      
      case 's':
      targetPosition = new PVector(width, 0.0f);
      break;
      
      case 'a':
      targetPosition = new PVector(0.0f, height);
      break;
      
      case 'd':
      targetPosition = new PVector(width, height);
      break;
      
    }
  
 }//updatetargetPosition
 
 void mouseClicked(){
   
   pinchOrigin = new PVector(mouseX, mouseY);
   
 }//update pinchOrigin 
 
 void update(){
   
   pinchPosition = new PVector(mouseX, mouseY);
   relative = PVector.sub(pinchOrigin, pinchPosition);
   
 }//update
 
 void render(){
   
   ellipse(pinchPosition.x, pinchPosition.y, 10.0f, 10.0f);//手の位置
   ellipse(pinchOrigin.x, pinchOrigin.y, 10.0f, 10.0f);//元のつまんだ位置
   line(pinchOrigin.x, pinchOrigin.y, pinchPosition.x, pinchPosition.y);//傾きの直線
   
   renderOrbit(targetPosition, 100.0f);
   
 }
 
  //兵士の軌道予測線------------------------------------------------------------------------
  //兵士の軌道を描画
  public void renderOrbit(PVector castlePosition, float v){
    println(castlePosition.x);
    
    int n = 1000;//描画のループ回数
  
    //二次曲線の係数を保存
    PVector parameter = new PVector();
    parameter = orbitParameter(castlePosition,  n).copy();
    //必要なxの増加量を保存
    //float dx = delta_x(v, parameter.x, parameter.y);
    
    /*兵士の軌道予測線を描画*/
    float _strokeWeight = 10.0f;
    strokeWeight(_strokeWeight);
    stroke(#FA122D);
    float t = 0;//媒介変数(t = 0 で(x, y) = (pinchOrigin.x, pinchOrigin.y), t = n で (x , y) = (castlePosition.x, castlePosition.y))
    PVector renderPosition = new PVector();//描画用、ループ中での曲線の位置ベクトル
    PVector preRenderPosition = new PVector();//一つ前のループの位置ベクトル
   
    preRenderPosition  = twoDegreeCarvePosition(pinchOrigin, t , parameter);
    t ++;
    renderPosition = twoDegreeCarvePosition(pinchOrigin, t, parameter);
    line(preRenderPosition.x, preRenderPosition.y, renderPosition.x, renderPosition.y );
   
    for(int i = 0; i < n;  i ++){
      
          renderPosition = twoDegreeCarvePosition(pinchOrigin, t, parameter);
          line(preRenderPosition.x, preRenderPosition.y, renderPosition.x, renderPosition.y );
          preRenderPosition  = twoDegreeCarvePosition(pinchOrigin, t , parameter);
          t ++;
    }
   
    strokeWeight(1.0f);
    stroke(0);
  }//renderOrbit
  
  /*兵士の軌道関数の係数を与える関数(媒介変数表示)
      x = x0 + at, y = y0 + bt + (b/2) * t^2 */
  public PVector orbitParameter(PVector castlePosition, float n){//nは曲線を描画するループの回数
    //相対ベクトルの傾きを出す。
    float m = relative.y / relative.x;
    //println(m);
    /*二次曲線の係数を計算*/
    float a = castlePosition.x / n;
    float b = (m / n) * castlePosition.x;
    float c = ( 2.0f / pow(n , 2.0f) ) * (castlePosition.y - m * castlePosition.x);
    /*係数をベクトルとして渡す。*/
    PVector parameter = new PVector(a , b , c);
    return parameter;
   
  }//orbitParameter
  //必要なxの増加量を算出
  //public float delta_x( float v, float a, float b){
    
  //  float delta_x = ( pow( pow(v , 2.0f) -1 , 0.5f) - b ) / (2 * a );
  //  return delta_x;
    
  //}
  //二次曲線の、媒介変数tに対するx, yの値を返す()
   public PVector twoDegreeCarvePosition(PVector startPosition, float t , PVector parameter){
     /*媒介変数に対応するx, y座標を計算*/
      float x = startPosition.x + parameter.x * t ;
      float y = startPosition.y + parameter.y * t + (parameter.z / 2.0f) * pow(t, 2.0f);
      /*x, yの値をベクトルとして渡す*/
      PVector r = new PVector(x, y);
      return r;
    }//twoDegreeCarve
  
  
  