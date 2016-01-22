module Api::V1
  class NotesController < ApiController

    def index
      render json: Note.all
    end

    def show
      render json: Note.find(params[:id])
    end

    def create
      note = Note.new(note_params)
      user = User.find(note_params[:user_id])
      note.user = user
      if note.save
        render json: note, status: :created
      else
        render json: { errors: note.errors }, status: :unprocessable_entity
      end
    end

    def update
      note = Note.find(params[:id])
      if note.update(note_params)
        render json: note
      else
        render json: { errors: note.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      note = Note.find(params[:id])
      note.destroy
      head :no_content
    end

    private

    def note_params
      params.require(:note).permit(:title, :content, :user_id)
    end
  end
end
