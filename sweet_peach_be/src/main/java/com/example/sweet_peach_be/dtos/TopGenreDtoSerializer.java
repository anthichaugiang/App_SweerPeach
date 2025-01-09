package com.example.sweet_peach_be.dtos;

import com.example.sweet_peach_be.dtos.TopGenreDto;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.SerializerProvider;
import com.fasterxml.jackson.databind.ser.std.StdSerializer;
import java.io.IOException;

public class TopGenreDtoSerializer extends StdSerializer<TopGenreDto> {

    public TopGenreDtoSerializer() {
        this(null);
    }

    protected TopGenreDtoSerializer(Class<TopGenreDto> t) {
        super(t);
    }

    @Override
    public void serialize(TopGenreDto value, JsonGenerator gen, SerializerProvider provider) throws IOException {
        gen.writeStartObject();
        gen.writeNumberField("id",value.getGenreId());
        gen.writeStringField("genreName", value.getGenreName());
        gen.writeNumberField("totalViewCount", value.getTotalViewCount());
        gen.writeEndObject();
    }
}

