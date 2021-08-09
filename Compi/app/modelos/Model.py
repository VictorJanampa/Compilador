#from app import app
#from app.controladores.controlador import tasks
from flask import jsonify, request
from flaskext.mysql import MySQL
import ply.lex as lex
import ply.yacc as yacc
import sys
import json
class Model:

    def __init__(self,app):
        self.mysql=MySQL()
        app.config['MYSQL_DATABASE_USER']='root'
        app.config['MYSQL_DATABASE_PASSWORD']='unsa12345'
        app.config['MYSQL_DATABASE_DB']='Silabete'
        app.config['MYSQL_DATABASE_HOST']='127.0.0.1'
        self.mysql.init_app(app)

        self.con=self.mysql.connect()
        self.cursor=self.con.cursor()
    def getCompilador(self):
        newdata = request.json
        print ("BODY JSON: " ,newdata)
        

        global data
        tokens = [

            'INT',
            'FLOAT',
            'NAME',
            'PLUS',
            'MINUS',
            'DIVIDE',
            'MULTIPLY',
            'EQUALS'

        ]

        t_PLUS = r'\+'
        t_MINUS = r'\-'
        t_MULTIPLY = r'\*'
        t_DIVIDE = r'\/'
        t_EQUALS = r'\='


        t_ignore = r' '

        def t_FLOAT(t):
            r'\d+\.\d+'
            t.value = float(t.value)
            return t

        def t_INT(t):
            r'\d+'
            t.value = int(t.value)
            return t

        def t_NAME(t):
            r'[a-zA-Z_][a-zA-Z_0-9]*'
            t.type = 'NAME'
            return t

        def t_error(t):
            print("Illegal characters!")
            t.lexer.skip(1)

        lexer = lex.lex()

        precedence = (

            ('left', 'PLUS', 'MINUS'),
            ('left', 'MULTIPLY', 'DIVIDE')

        )

        def p_calc(p):
            '''
            calc : expression
                | var_assign
                | empty
            '''
            data=run(p[1])
            dic={"resultado": data}
            json_object = json.dumps(dic, indent = 2)
            with open("ejemplo.json", "w") as outfile:
                outfile.write(json_object)

        def p_var_assign(p):
            '''
            var_assign : NAME EQUALS expression
            '''
            p[0] = ('=', p[1], p[3])

        def p_expression(p):
            '''
            expression : expression MULTIPLY expression
                    | expression DIVIDE expression
                    | expression PLUS expression
                    | expression MINUS expression
            '''
            p[0] = (p[2], p[1], p[3])

        def p_expression_int_float(p):
            '''
            expression : INT
                    | FLOAT
            '''
            p[0] = p[1]

        def p_expression_var(p):
            '''
            expression : NAME
            '''
            p[0] = ('var', p[1])

        def p_error(p):
            print("Syntax error found!")

        def p_empty(p):
            '''
            empty :
            '''
            p[0] = None

        parser = yacc.yacc()

        env = {}

        def run(p):
            global env
            if type(p) == tuple:
                if p[0] == '+':
                    return run(p[1]) + run(p[2])
                elif p[0] == '-':
                    return run(p[1]) - run(p[2])
                elif p[0] == '*':
                    return run(p[1]) * run(p[2])
                elif p[0] == '/':
                    return run(p[1]) / run(p[2])
                elif p[0] == '=':
                    env[p[1]] = run(p[2])
                    return ''
                elif p[0] == 'var':
                    if p[1] not in env:
                        return 'Undeclared variable found!'
                    else:
                        return env[p[1]]
            else:
                return p


        s = request.json["resultado"]

        parser.parse(s)
        print (s)
        return "newdata"
    def getSilabos(self):
        silabos = []
        self.cursor.execute("SELECT * from Silabo")
        tmp = self.cursor.fetchall()
        for silabo in tmp:
            s = {}
            s["id"] = silabo[0]
            s["sem"] = silabo[1]
            silabos.append(s)

        return jsonify(silabos)
    
    
    def addDocente(self):
        print(request.json)
        query = f'INSERT INTO Docente (doc_dni , doc_nom , doc_ape_pat , doc_ape_mat , doc_grad_aca , dep_aca_ide ) VALUES ({request.json["dni"]},"{request.json["name"]}","{request.json["lastname1"]}","{request.json["lastname2"]}","{request.json["gradoacademico"]}",{request.json["depAcademico"]})'
        print (query)
        self.cursor.execute(query)
        self.con.commit()
        return "Insert Succesful"

    def searchDocente(self, dni):
        Docentes = []
        query = "SELECT doc_ide ,doc_dni , doc_nom , doc_ape_pat , doc_ape_mat , doc_grad_aca , dep_aca_ide FROM Docente WHERE doc_dni = %s AND doc_del_date is null "
        self.cursor.execute(query, (dni,))
        data = self.cursor.fetchall()
        
        for dnis in data:
            s = {}
            s["doc_ide"] = dnis[0]
            s["doc_dni"] = dnis[1]
            s["doc_nom"] = dnis[2]
            s["doc_ape_mat"] = dnis[3]
            s["doc_ape_pat"] = dnis[4]
            s["doc_grad_aca"] = dnis[5]
            s["dep_aca_ide"] = dnis[6]
            
            Docentes.append(s)
        
        return jsonify(Docentes[0])


    def deleteDocente(self,dni):
        query = "UPDATE Docente SET doc_del_date=now() WHERE doc_dni= %s"
        self.cursor.execute(query, (dni,))
        self.con.commit()
        return "Docente Eliminado"

    def updateDocente(self ):
        newdata = request.json
        print ("BODY JSON: ",newdata)
        t = newdata["doc_ide"]
        #query = "UPDATE Docente SET doc_dni = %s , doc_nom = %s, doc_ape_pat = %s, doc_ape_mat = %s, doc_grad_aca = %s, dep_aca_ide = %s WHERE doc_ide = %s " , ( newdata["doc_dni"],newdata["doc_nom"] ,newdata["doc_ape_pat"],newdata["doc_ape_mat"],newdata["doc_grad_aca"],newdata["dep_aca_ide"],newdata["doc_ide"] )
        query = "UPDATE Docente SET doc_dni = %s , doc_nom = %s, doc_ape_pat = %s, doc_ape_mat = %s, doc_grad_aca = %s, dep_aca_ide = %s WHERE doc_ide = %s" 
        
        #print (query)

        self.cursor.execute(query,( newdata["doc_dni"],newdata["doc_nom"] ,newdata["doc_ape_pat"],newdata["doc_ape_mat"],newdata["doc_grad_aca"],newdata["dep_aca_ide"],newdata["doc_ide"]))
        self.con.commit()
        return "Docente Actualizado"
        
  

    def searchCurs(self, cod):
        Cursos = []
        query = "SELECT cur_cod , cur_nom , cur_sem , cur_dur , cur_hor_teo , cur_hor_prac , cur_hor_lab , cur_credi , cur_fund ,cur_ide FROM Curso WHERE cur_cod = %s "
        
        self.cursor.execute(query, (cod,))
        data = self.cursor.fetchall()

        for codi in data:
            s = {}
            s["cur_cod"] = codi[0]
            s["cur_nom"] = codi[1]
            s["cur_sem"] = codi[2]
            s["cur_dur"] = codi[3]
            s["cur_hor_teo"] = codi[4]
            s["cur_hor_prac"] = codi[5]
            s["cur_hor_lab"] = codi[6]
            s["cur_credi"] = codi[7]
            s["cur_fund"] = codi[8]
            s["cur_ide"] = codi[9]
            
            Cursos.append(s)
            
        return jsonify(Cursos[0])
    
    def agregarSilabo(self, sil_per, sil_inf_espe, sil_comp_asig, sil_eva_apre, sil_req_apro,cur_ide):
        params={
            "sil_per":sil_per, 
            "sil_inf_espe":sil_inf_espe, 
            "sil_comp_asig":sil_comp_asig, 
            "sil_eva_apre":sil_eva_apre, 
            "sil_req_apro":sil_req_apro,
            "cur_ide":cur_ide
        }
        query = """INSERT INTO Silabo (sil_per , sil_inf_espe , sil_comp_asig , sil_eva_apre , sil_req_apro, cur_ide ) VALUES (%(sil_per)s , %(sil_inf_espe)s , %(sil_comp_asig)s , %(sil_eva_apre)s , %(sil_req_apro)s, %(cur_ide)s)"""
        self.cursor.execute(query,params)
        self.con.commit()
        return "Insert Succesful"
    
    
