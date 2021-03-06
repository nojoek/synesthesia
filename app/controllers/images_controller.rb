class ImagesController < ApplicationController

include ImagesHelper


  def index
    @images = Image.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @images }
    end
  end

  def show
    @image = Image.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @image }
    end
  end

  def new
    @image = Image.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @image }
    end
  end

  ### NOT IMPLEMENTED BUT MIGHT IMPLEMENT IN THE FUTURE  ###
  # def edit
  #   @image = Image.find(params[:id])
  # end

  def create
    @image = Image.new(params[:image])
    @image.user_id = current_user.id

    ###PROCESS IMAGE###

    respond_to do |format|
      if @image.save

        img_url = (Rails.root.to_s + "/public" + @image.file.url.split("?")[0])
        puts "PATH TO IMG: #{img_url}"

        fname = sanitize_filename( ( @image.name + current_user.username).gsub(/\s+/, "") )

        make_midi(img_url, fname)

        @sound = Sound.new
        @sound.name = @image.name
        @sound.url = get_url(img_url, fname)
        @sound.image_id = @image.id

        @sound.save

        format.html { redirect_to current_user, notice: 'Syneth was successfully created.' }
        format.json { render json: current_user, status: :created, location: @image }
      else
        format.html { render action: "new"}
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end
  end

  ### NOT IMPLEMENTED BUT MIGHT IMPLEMENT IN THE FUTURE  ###
  # def update
  #   @image = Image.find(params[:id])

  #   respond_to do |format|
  #     if @image.update_attributes(params[:image])
  #       format.html { redirect_to @image, notice: 'Image was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @image.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def destroy
    @image = Image.find(params[:id])
    @user = current_user
    @image.destroy

    respond_to do |format|
      format.js
      format.html { redirect_to images_url }
      format.json { head :no_content }
    end
  end
end
