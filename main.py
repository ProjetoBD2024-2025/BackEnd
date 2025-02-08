from flask import Flask, request, send_file, jsonify
import io
import unicodedata
import mimetypes
from classes import Projeto, Tarefa, Cliente, Equipe, Documentos
from flask_cors import CORS
import base64

app = Flask(__name__)
app.json.sort_keys = False

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------
# CRUD PARA PROJETOS ----------------------------------------------------------------------------------------------------------------------------------------------
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------

CORS(app, resources={
    r"/projetos/*": {"origins": "http://localhost:5173"},
    r"/clientes/*": {"origins": "http://localhost:5173"},
    r"/equipes/*": {"origins": "http://localhost:5173"}
})

# Visualizar todos os projetos
@app.route('/projetos', methods=['GET'])
def get_projects():
    
    consulta = Projeto().get_all_projetos()
    result = [
        {
            "Nome": item[0],
            "ID_Projeto": item[1],
            "Descricao": item[2],
            "Data_Inicio": item[3],
            "Data_Fim_Prev": item[4],
            "Status": item[5],
            "Orcamento_previsto": item[6],
            "Cliente_Nome": item[9],  
            "Cliente_Telefone": item[10],
            "Cliente_Email": item[11],
            "Cliente_Endereco": item[12],
            "Equipe_Nome": item[13],
            "Supervisor_Nome": item[14]
        } for item in consulta
    ]

        
    return jsonify(result), 200


# Visualizar projeto específico
@app.route('/projetos/<int:projeto_id>', methods=['GET'])
def get_projects_id(projeto_id):

    item = Projeto().get_projeto(projeto_id)
    result = {
        "Nome": item[0],
        "ID_Projeto": item[1],
        "Descricao": item[2],
        "Data_Inicio": item[3],
        "Data_Fim_Prev": item[4],
        "Status": item[5],
        "Orcamento_previsto": item[6],
        "Contratante": {
            "Cliente_ID": item[7],  
            "Cliente_Nome": item[12],  
            "Cliente_Telefone": item[13],
            "Cliente_Email": item[14],
            "Cliente_Endereco": item[15],
        },
        "Equipe_Resp": {
            "ID_Equipe": item[8],
            "Nome": item[10],
            "Supervisor": item[14],
            "Supervisor_Nome": item[16]
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
def update_task(projeto_id, tarefa_id):

    data = request.get_json()

    Tarefa().edit_tarefa(tarefa_id, data)

    return jsonify({'Mensagem': 'Projeto editado com sucesso!'}), 200

@app.route('/clientes', methods=['GET'])
def get_clients():
    
    consulta = Cliente().get_all_clientes()
    result = [
        {
            "Nome": item[0],
            "Telefone": item[2],
            "Email": item[3],
            "CPF_CNPJ": item[1]
        } for item in consulta
    ]   
    return jsonify(result), 200

@app.route('/equipes', methods=['GET'])
def get_teams():
    
    consulta = Equipe().get_all_equipes()
    result = [
        {
            "Nome": item[1],
            "ID_Equipe": item[0],
            "Supervisor": item[2]
        } for item in consulta
    ]   
    return jsonify(result), 200

@app.route('/projetos/<int:projeto_id>/documentos', methods=['POST'])
def upload_documento(projeto_id):
    if 'file' not in request.files:
        return jsonify({"erro": "Nenhum arquivo enviado"}), 400

    file = request.files['file']
    nome_arquivo = request.form.get("nome_arquivo", file.filename)
    tipo_arquivo = request.form.get("tipo_arquivo", file.filename.split('.')[-1])
    documento_blob = file.read()

    try:
        doc_manager = Documentos()
        doc_manager.add_documento(projeto_id, nome_arquivo, tipo_arquivo, documento_blob)

        return jsonify({"mensagem": "Documento adicionado com sucesso!"}), 201

    except Exception as e:
        return jsonify({"erro": str(e)}), 500

@app.route('/projetos/<int:projeto_id>/documentos', methods=['GET'])
def get_documents(projeto_id):
    documentos = Documentos().get_documento(projeto_id)

    if not documentos:
        return jsonify({"mensagem": "Nenhum documento encontrado para este projeto."}), 404

    result = []
    for item in documentos:
        arquivo_blob = item[3]  # Documento em formato BLOB
        
        if isinstance(arquivo_blob, str):  # Se estiver como string, converte para bytes
            arquivo_blob = arquivo_blob.encode("utf-8")

        # Garante que só tenta codificar se for um valor válido
        arquivo_base64 = base64.b64encode(arquivo_blob).decode("utf-8") if arquivo_blob else None

        result.append({
            "ID_Documento": item[0],
            "Nome_Arquivo": item[2],
            "Tipo_Arquivo": item[1],
            "Arquivo": arquivo_base64
        })

    return jsonify(result), 200

@app.route('/projetos/<int:projeto_id>/documentos/<int:documento_id>', methods=['GET'])
def get_documento(projeto_id, documento_id):
    doc = Documentos().get_documentoDownload(documento_id)  # Busca o documento pelo ID

    if not doc:
        return jsonify({"erro": "Documento não encontrado"}), 404
    nome_arquivo = doc[0][2]
    tipo_arquivo = doc[0][3]
    arquivo_bin = doc[0][4]

    if not arquivo_bin:
        return jsonify({"erro": "Arquivo não encontrado no banco de dados"}), 404
    
    if not isinstance(nome_arquivo, str):
        nome_arquivo = str(nome_arquivo)
    if not nome_arquivo:
        nome_arquivo = "documento_sem_nome"

    def remover_acentos(texto):
        return ''.join(c for c in unicodedata.normalize('NFKD', texto) if unicodedata.category(c) != 'Mn')

    nome_arquivo_ascii = remover_acentos(nome_arquivo).replace(" ", "_")  # Substitui espaços por "_"

    if not tipo_arquivo:
        tipo_arquivo, _ = mimetypes.guess_type(nome_arquivo_ascii)
    if not tipo_arquivo:
        tipo_arquivo = "application/octet-stream"

    if isinstance(arquivo_bin, str):
        arquivo_bin = arquivo_bin.encode("utf-8")

    file_stream = io.BytesIO(arquivo_bin)

    return send_file(file_stream, as_attachment=True, download_name=nome_arquivo_ascii, mimetype=tipo_arquivo)

if __name__ == '__main__':
    app.run(debug=True)
