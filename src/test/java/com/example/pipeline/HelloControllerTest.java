package com.example.pipeline;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(HelloController.class)
class HelloControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Nested
    @DisplayName("GET /say-hello")
    class GetHello {

        @Test
        @DisplayName("should return 'Hello mate!' with 200 status when called")
        void shouldReturnGreetingMessage() throws Exception {
            // Given
            String expectedResponse = "Hello mate!";

            // When & Then
            mockMvc.perform(get("/say-hello"))
                    .andExpect(status().isOk())
                    .andExpect(content().string(expectedResponse));
        }

        @Test
        @DisplayName("should return JSON content type")
        void shouldReturnJsonContentType() throws Exception {
            mockMvc.perform(get("/say-hello"))
                    .andExpect(status().isOk())
                    .andExpect(content().contentType("text/plain;charset=UTF-8"));
        }
    }
}