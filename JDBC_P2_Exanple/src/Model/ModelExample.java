package Model;

public class ModelExample {
    private int id_movie;
    private String title;
    private int id_director;
    private int year;
    private int duration;
    private String country;
    private int movie_facebook_likes;
    private double imdb_score;
    private long gross;
    private long budget;

    public int getId_movie() {
        return id_movie;
    }

    public void setId_movie(int id_movie) {
        this.id_movie = id_movie;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getId_director() {
        return id_director;
    }

    public void setId_director(int id_director) {
        this.id_director = id_director;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getCountry() {
        return country;
    }

    public void setCountry(String country) {
        this.country = country;
    }

    public int getMovie_facebook_likes() {
        return movie_facebook_likes;
    }

    public void setMovie_facebook_likes(int movie_facebook_likes) {
        this.movie_facebook_likes = movie_facebook_likes;
    }

    public double getImdb_score() {
        return imdb_score;
    }

    public void setImdb_score(double imdb_score) {
        this.imdb_score = imdb_score;
    }

    public long getGross() {
        return gross;
    }

    public void setGross(long gross) {
        this.gross = gross;
    }

    public long getBudget() {
        return budget;
    }

    public void setBudget(long budget) {
        this.budget = budget;
    }

    @Override
    public String toString() {
        return "ModelExample{" +
                "id_movie=" + id_movie +
                ", title='" + title + '\'' +
                ", id_director=" + id_director +
                ", year=" + year +
                ", duration=" + duration +
                ", country='" + country + '\'' +
                ", movie_facebook_likes=" + movie_facebook_likes +
                ", imdb_score=" + imdb_score +
                ", gross=" + gross +
                ", budget=" + budget +
                '}';
    }
}
