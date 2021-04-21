package uml.dependency.first;

//普通人
public class Person {

    //买手机
    public CellPhone buyCellPhone(){
        return new CellPhone();
    }
    
    //买个手机玩游戏
    public void play(){
        CellPhone cellPhone = buyCellPhone();
        cellPhone.playGames();
    }
}