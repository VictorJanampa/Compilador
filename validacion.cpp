
#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <map>
#include <stack>
#include <queue>
#include <algorithm>
#include<string>
using namespace std;

vector <string> removeSpacios(string str)
{
    string word = "";
    vector <string> aux;
   
    for (auto x : str) 
    {
        if (x == ' ')
        {
    
            aux.push_back(word);
            word = "";
        }
        else {
            word = word + x;
        }
    }
    aux.push_back(word);
    return aux;
}
  



int main(){
    
    string EstadoInicial, cadena;
    //vector <string>cadena;
    int tam;
    cout << "Inserte el estado inicial"<<endl;
    std::getline(std::cin, EstadoInicial);
    cout << "Inserte la cadena a evaluar"<<endl;
    std::getline(std::cin, cadena);
    vector<string>temp2;
    temp2=removeSpacios(cadena);
    
    
    



    
std::map<string,std::map<string,vector <string>>> mymap;
//std::map<string,std::map<string,string>>::iterator it;
//map<string, string>::iterator ptr;

mymap["E"]["("]={"T","E'"};
mymap["E"]["id"]={"T","E'"};

mymap["E'"]["+"]={"+","T","E'"};
mymap["E'"][")"]={"e"};
mymap["E'"]["$"]={"e"};

mymap["T"]["("]={"F","T'"};
mymap["T"]["id"]={"F","T'"};

mymap["T'"]["+"]={"e"};
mymap["T'"]["*"]={"*","F","T'"};
mymap["T'"][")"]={"e"};
mymap["T'"]["$"]={"e"};

mymap["F"]["("]={"(","E",")"};
mymap["F"]["id"]={"id"};




queue<string> imput;
//insertamos la cadena obtenida 
for (auto i = temp2.begin(); i != temp2.end(); ++i){
       imput.push(*i);
}



stack<string> st;
st.push("$");
st.push(EstadoInicial);
imput.push("$");

bool accepted = true;

while(!st.empty() && !imput.empty()){
    if(st.size() == 1 && imput.size() ==1){
            cout<<"String valido"<<endl;
            break;
    } 
    else if(imput.front() == st.top())  {

        st.pop();
        imput.pop();
        //cout<<"IGUAL"<<endl;

    }

    else {
        string stack_top = st.top();
        st.pop();

        cout<<stack_top << endl;
        for (auto i = mymap[stack_top][imput.front()].rbegin(); i != mymap[stack_top][imput.front()].rend(); ++i){
            if (*i !="e") {
                    
                    //cout<<mymap[temp1][temp2]<<endl;
                    st.push(*i);
                    //cout<<"Elementos vector"<<*i<<endl;
                }
       
            else {
                //cout<<"vacio"<<endl;
                break;
            }
        }
    }
  
}

return 0;
}
