# --*-- coding:utf-8 --*--

class AvaliadoresController < ApplicationController
  before_filter :authenticate_avaliador!
  before_filter :current_avaliador

  def index
    @title = "Home"
  end

  def new
    if current_avaliador.admin
      @avaliador = Avaliador.new
    end

    # unless current_avaliador.admin.empty?
    #   flash[:notice] => t("avaliadores.notifications.admin_error")
    # end
  end

  def create
    @avaliador = Avaliador.new(params[:avaliador])
    if @avaliador.save
      redirect_to avaliador_index_path, :notice => I18n.t('avaliadores.notifications.successfully_registrated', :user_name=> @avaliador.nome)
    else
      render :action => :new
    end
  end

  #### Metodos para editar o Status de determinado avaliador #####

    def edit
        @avaliador = Avaliador.find(params[:id])
        @admin = current_avaliador
    end

    def update
        @avaliador = Avaliador.find(params[:id])
        @admin = current_avaliador
        if @avaliador.update_attributes(params[:avaliador])
            redirect_to total_avaliadores_path
            flash[:notice] = "Status  - atualizado"
        else
            render action: :edit
        end
    end

  #################################################################

  #### Localizador de elementos(aluno:, avaliador:, atividade:) ###

  def localizar_atividade
    @atividade_aluno = Atividade.where(:avalidor_id => current_avaliador.id ).paginate(
    :page => params[:page], :per_page=>5)
  end

  def total_alunos
    @alunos = Aluno.paginate(:page => params[:page], :per_page=>10)
  end

  def total_avaliadores
    @avaliadores = Avaliador.paginate(:page => params[:page], :per_page=>10)
  end
  
  def listar_atividades
    @atividades = Atividade.paginate(:page => params[:page], :per_page=>4)
  end

  #################################################################

end