import mysql.connector


# -----------------------------------------------------------------------------------------------------------------------------------------------------------------


class Engenheiro:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Admin123",
            database="Projeto_bd"
        )

        self.cursor = self.connection.cursor()


    def get_engenheiro(self, Identifier):

        arg = f"""SELECT Engenheiros.*, EquipeProjeto.* 
                  FROM (SELECT * FROM Engenheiro WHERE CREA = {Identifier}) AS Engenheiros 
                  JOIN (SELECT Equipes.ID_Equipe, Equipes.Nome, Equipes.Supervisor, Projetos.ID_Projeto, Projetos.Contratante
                        FROM Equipe AS Equipes 
                        INNER JOIN Projeto AS Projetos 
                        ON Equipes.ID_Equipe = Projetos.Equipe_Resp) AS EquipeProjeto
                  ON Engenheiros.CREA = EquipeProjeto.Supervisor"""

        self.cursor.execute(arg)
        result = self.cursor.fetchone()
        
        return result


    def delete_engenheiro(self, Identifier):

        arg = f"DELETE FROM Engenheiro WHERE ID = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()


    def edit_engenheiro(self, Identifier, values):

        arg = """UPDATE Engenheiro SET Nome = '{0}',
                        CREA = '{1}',
                        Telefone = '{2}',
                        Email = '{3}'
                        WHERE CREA = {4}""".format(values['Nome'],
                                                   values['CREA'],
                                                   values['Telefone'],
                                                   values['Email'],
                                                   Identifier)
        
        self.cursor.execute(arg)
        self.connection.commit()


# -----------------------------------------------------------------------------------------------------------------------------------------------------------------


class Projeto:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Admin123",
            database="Projeto_bd"
        )

        self.cursor = self.connection.cursor()


    def get_all_projetos(self):

        arg = "SELECT * FROM Projeto"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()
        
        return result


    def get_projeto(self, Identifier):

        arg = f"""SELECT Projetos.*, Equipes.* 
                  FROM (SELECT * FROM Projeto WHERE ID_Projeto = {Identifier}) AS Projetos 
                  JOIN Equipe AS Equipes 
                  ON Projetos.Equipe_Resp = Equipes.ID_Equipe"""

        self.cursor.execute(arg)
        result = self.cursor.fetchone()

        return result
    

    def add_projeto(self, values):

        arg = """INSERT INTO Projeto (Nome, Descricao, Data_Inicio, Data_Fim_Prev, Status_, Orcamento_previsto, Contratante, Equipe_Resp)
                    VALUES ('{0}','{1}','{2}','{3}','{4}',{5},'{6}',{7})""".format(values['Nome'],
                                                                                   values['Descricao'],
                                                                                   values['Data_Inicio'],
                                                                                   values['Data_Fim_Prev'],
                                                                                   values['Status'],
                                                                                   values['Orcamento_previsto'],
                                                                                   values['Contratante'],
                                                                                   values['Equipe_Resp'])
        
        self.cursor.execute(arg)
        self.connection.commit()


    def delete_projeto(self, Identifier):

        arg = f"DELETE FROM Projeto WHERE ID_Projeto = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()


    def edit_projeto(self, Identifier, values):

        arg = """UPDATE Projeto SET Nome = '{0}',
                                    Descricao = '{1}',
                                    Data_Inicio = '{2}',
                                    Data_Fim_Prev = '{3}',
                                    Status_ = '{4}',
                                    Orcamento_previsto = {5},
                                    Contratante = '{6}',
                                    Equipe_Resp = {7} 
                                    WHERE ID_Projeto = {8}""".format(values['Nome'],
                                                                    values['Descricao'],
                                                                    values['Data_Inicio'],
                                                                    values['Data_Fim_Prev'],
                                                                    values['Status'],
                                                                    values['Orcamento_previsto'],
                                                                    values['Contratante'],
                                                                    values['Equipe_Resp'],
                                                                    Identifier)
        
        self.cursor.execute(arg)
        self.connection.commit()


# -----------------------------------------------------------------------------------------------------------------------------------------------------------------


'''class Equipe:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Admin123",
            database="Projeto_bd"
        )

        self.cursor = self.connection.cursor()


    def get_all_equipes(self):

        arg = "SELECT * FROM Equipes"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()

        return result
    

    def get_equipe(self, Identifier):

        arg = f"SELECT * FROM Equipes WHERE ID = {Identifier}"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()

        return result
    

    def add_equipe(self, Identifier, values):

        arg = f"""INSERT INTO Equipes (ID, NOME, DESCRICAO, DATA_INICIO, DATA_FIM_PREV, STATUS, ORCAMENTO_PREVISTO, CONTRATANTE, EQUIPE_RESP)
                    VALUES ({Identifier},{values[0]},{values[1]},{values[2]},{values[3]},{values[4]},{values[5]},{values[6]},{values[7]})"""
        
        self.cursor.execute(arg)
        self.connection.commit()


    def delete_equipe(self, Identifier):

        arg = f"DELETE FROM Equipes WHERE ID = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()

    
    def edit_equipe(self, Identifier):
        pass'''


# -----------------------------------------------------------------------------------------------------------------------------------------------------------------


class Tarefa:

    def __init__(self):

        self.connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Admin123",
            database="Projeto_bd"
        )

        self.cursor = self.connection.cursor()


    def add_tarefa(self, project_id, values):

        arg = """INSERT INTO Tarefa (ID_Projeto, Nome, Descricao, Data_Inicio, Data_Fim_Prev, Status_)
                    VALUES ({0},'{1}','{2}','{3}','{4}','{5}')""".format(project_id,
                                                                         values['Nome'],
                                                                         values['Descricao'],
                                                                         values['Data_Inicio'],
                                                                         values['Data_Fim_Prev'],
                                                                         values['Status'])
        
        self.cursor.execute(arg)
        self.connection.commit()


    def get_all_tarefas(self, project_id):
        
        arg = f"SELECT * FROM Tarefa WHERE ID_Projeto = {project_id}"
        self.cursor.execute(arg)
        result = self.cursor.fetchall()
        
        return result
    

    def get_tarefa(self, Identifier):

        arg = f"SELECT * FROM Tarefa WHERE ID_Tarefa = {Identifier}"

        self.cursor.execute(arg)
        result = self.cursor.fetchone()

        return result
    

    def delete_tarefa(self, Identifier):

        arg = f"DELETE FROM Tarefa WHERE ID_Tarefa = {Identifier}"
        self.cursor.execute(arg)
        self.connection.commit()


    def edit_tarefa(self, Identifier, values):

        arg = """UPDATE Tarefa SET ID_Projeto = {0},
                                   Nome = '{1}'
                                   Descricao = '{2}',
                                   Data_Inicio = '{3}',
                                   Data_Fim_Prev = '{4}',
                                   Status_ = '{5}' 
                                   WHERE ID_Tarefa = {6}""".format(values['ID_Projeto'],
                                                                   values['Nome'],
                                                                   values['Descricao'],
                                                                   values['Data_Inicio'],
                                                                   values['Data_Fim_Prev'],
                                                                   values['Status'],
                                                                   Identifier)
        
        self.cursor.execute(arg)
        self.connection.commit()
