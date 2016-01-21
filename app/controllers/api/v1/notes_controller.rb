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
      if note.save
        render json: note, status: 201
      else
        render json: { errors: note.errors }, status: 422
      end
    end

    def update
      note = Note.find(params[:id])
      if note.update(note_params)
        render json: note
      else
        render json: { errors: note.errors }, status: 422
      end
    end

    def destroy
      note = Note.find(params[:id])
      note.destroy
      head 204
    end

    private

    def note_params
      params.require(:note).permit(:title, :content)
    end
  end
end
