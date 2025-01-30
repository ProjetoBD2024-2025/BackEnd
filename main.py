from flask import Flask, request, jsonify
from classes import Projeto, Engenheiro, Tarefa

app = Flask(__name__)
app.json.sort_keys = False

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------
# CRUD PARA PROJETOS ----------------------------------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------


# Visualizar todos os projetos
@app.route('/projetos', methods=['GET'])
def get_projects():
    
    consulta = Projeto().get_all_projetos()
    result = [
        {
            "Nome": item[0],
            "Descricao": item[2],
            "Data_Inicio": item[3],
            "Data_Fim_Prev": item[4],
            "Status": item[5],
            "Orcamento_previsto": item[6],
            "Contratante": item[7],
            "Equipe_Resp": item[8]
         } for item in consulta]
    
    return jsonify(result), 200


# Visualizar projeto específico
@app.route('/projetos/<int:projeto_id>', methods=['GET'])
def get_projects_id(projeto_id):

    item = Projeto().get_projeto(projeto_id)
    result = {
                "Nome": item[0],
                "Descricao": item[2],
                "Data_Inicio": item[3],
                "Data_Fim_Prev": item[4],
                "Status": item[5],
                "Orcamento_previsto": item[6],
                "Contratante": item[7],
                "Equipe_Resp": {
                    "ID_Equipe": item[9],
                    "Nome": item[10],
                    "Supervisor": item[11]
                    }
                }
    
    return jsonify(result), 200


#Adicionar projeto
@app.route('/projetos', methods=['POST'])
def post_projects():

    data = request.get_json()

    Projeto().add_projeto(data)

    return jsonify({'Mensagem': 'Projeto cadastrado com sucesso!'}), 201


#Deletar projeto específico
@app.route('/projetos/<int:projeto_id>', methods=['DELETE'])
def exclude_project(projeto_id):
    
    Projeto().delete_projeto(projeto_id)

    return jsonify({'Mensagem': 'Projeto excluído com sucesso!'}), 200


#Editar projeto específico
@app.route('/projetos/edit/<int:projeto_id>', methods=['PUT'])
def update_project(projeto_id):

    data = request.get_json()

    Projeto().edit_projeto(projeto_id, data)

    return jsonify({'Mensagem': 'Projeto editado com sucesso!'}), 200


# -----------------------------------------------------------------------------------------------------------------------------------------------------------------
# CRUD PARA ENGENHEIRO --------------------------------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------


# Visualizar dados do engenheiro
@app.route('/engenheiro/<int:crea>', methods=['GET'])
def get_enginer(crea):

    Enginer = Engenheiro().get_engenheiro(crea)
    result = {
                "Nome": Enginer[0],
                "CREA": Enginer[1],
                "Telefone": Enginer[2],
                "Email": Enginer[3],
                "Projeto Atual": {
                    "ID do Projeto": Enginer[11],
                    "Contratante": Enginer[12]
                    },
                "Equipe": {
                    "ID da Equipe": Enginer[8],
                    "Nome": Enginer[9]
                    }
                }
    
    return jsonify(result), 200


#Deletar conta de engenheiro
@app.route('/engenheiro/<int:crea>', methods=['DELETE'])
def exclude_enginer(crea):
    
    Engenheiro().delete_engenheiro(crea)

    return jsonify({'Mensagem': 'Projeto excluído com sucesso!'}), 200


#Editar conta de engenheiro
@app.route('/engenheiro/edit/<int:crea>', methods=['PUT'])
def update_enginer(crea):

    data = request.get_json()

    Engenheiro().edit_engenheiro(crea, data)

    return jsonify({'Mensagem': 'Projeto editado com sucesso!'}), 200


# -----------------------------------------------------------------------------------------------------------------------------------------------------------------
# CRUD PARA TAREFA ------------------------------------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------


# Visualizar todas as tarefas de um projeto
@app.route('/projetos/<int:projeto_id>/tarefas', methods=['GET'])
def get_tasks(projeto_id):
    
    consulta = Tarefa().get_all_tarefas(projeto_id)
    result = [
        {
            "Nome": item[2],
            "Status": item[6]
         } for item in consulta]
    
    return jsonify(result), 200


# Visualizar tarefa específica de um projeto
@app.route('/projetos/<int:projeto_id>/tarefas/<int:tarefa_id>', methods=['GET'])
def get_tasks_id(projeto_id, tarefa_id):

    item = Tarefa().get_tarefa(tarefa_id)
    result = {
                "Nome": item[2],
                "Descricao": item[3],
                "Data_Inicio": item[4],
                "Data_Fim_Prev": item[5],
                "Status": item[6],
                }
    
    return jsonify(result), 200


#Adicionar tarefa em um projeto
@app.route('/projetos/<int:projeto_id>/tarefas', methods=['POST'])
def post_tasks(projeto_id):

    data = request.get_json()

    Tarefa().add_tarefa(projeto_id, data)

    return jsonify({'Mensagem': 'Tarefa cadastrada com sucesso!'}), 201


#Deletar tarefa específica em um projeto
@app.route('/projetos/<int:projeto_id>/tarefas/<int:tarefa_id>', methods=['DELETE'])
def exclude_tasks(projeto_id, tarefa_id):
    
    Tarefa().delete_tarefa(tarefa_id)

    return jsonify({'Mensagem': 'Tarefa excluída com sucesso!'}), 200


#Editar tarefa em projeto
@app.route('/projetos/<int:projeto_id>/tarefas/<int:tarefa_id>/edit', methods=['PUT'])
def update_project(projeto_id, tarefa_id):

    data = request.get_json()

    Tarefa().edit_tarefa(tarefa_id, data)

    return jsonify({'Mensagem': 'Projeto editado com sucesso!'}), 200


if __name__ == '__main__':
    app.run(debug=True)
