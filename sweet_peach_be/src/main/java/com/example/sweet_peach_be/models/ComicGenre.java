
package com.example.sweet_peach_be.models;
import jakarta.persistence.*;
@Entity
@Table(name = "comic_genres")
public class ComicGenre {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "comic_id")
    private Comic comic;

    @ManyToOne
    @JoinColumn(name = "genre_id")
    private Genre genre;

    // Getters and setters

    public void setComic(Comic comic) {
        this.comic = comic;
    }

    public void setGenre(Genre genre) {
        this.genre = genre;
    }

    public Comic getComic() {
        return comic;
    }

    public Genre getGenre() {
        return genre;
    }
}
