{-# LANGUAGE OverloadedStrings #-}

import Web.Scotty
import Control.Monad.IO.Class (liftIO)
import System.Random (randomRIO)
import Data.Text.Lazy (Text)
import qualified Data.Text.Lazy as T
import Text.Printf (printf)

-- Definindo um tipo para os dados RGB
data RGB = RGB
    { r :: Int
    , g :: Int
    , b :: Int
    } deriving (Show, Eq)

-- Função para gerar uma cor RGB aleatória
randomRGB :: IO RGB
randomRGB = do
    r <- randomRIO (0, 255)
    g <- randomRIO (0, 255)
    b <- randomRIO (0, 255)
    return $ RGB r g b

-- Função para converter RGB para string de estilo CSS
rgbToStyle :: RGB -> String
rgbToStyle (RGB r g b) = "rgb(" ++ show r ++ ", " ++ show g ++ ", " ++ show b ++ ")"

-- Função para calcular a distância euclidiana entre duas cores RGB
colorDistance :: RGB -> RGB -> Double
colorDistance (RGB r1 g1 b1) (RGB r2 g2 b2) = 
    sqrt (fromIntegral ((r2 - r1) ^ 2 + (g2 - g1) ^ 2 + (b2 - b1) ^ 2))

-- Função para calcular a pontuação baseada na distância
calculateScore :: RGB -> RGB -> Int
calculateScore color1 color2 =
    let maxDistance = 441.67  -- Distância máxima entre duas cores RGB
        distance = colorDistance color1 color2
        score = 100 * (1 - (distance / maxDistance))
    in round score  -- Arredondar para o inteiro mais próximo

-- Rota principal
main :: IO ()
main = scotty 3000 $ do
    get "/" $ do
        randomColor <- liftIO randomRGB  -- Gera a cor aleatória
        let randomColorStyle = rgbToStyle randomColor
        let formHtml = 
                        "<div style='display: flex; flex-direction: column; align-items: center; justify-content: center; width:99%; height:98vh; background-color: gray; '>"++
                        "<div style='width: 100px; height: 100px; background-color: " ++ randomColorStyle ++ ";'></div><form action=\"/submit\" method=\"post\">\n\
                        \   <label style='margin-top:10px;' for=\"r\">R:</label>\n\
                        \   <input style='margin-top:10px;' type=\"number\" name=\"r\" min=\"0\" max=\"255\" required /><br>\n\
                        \   <label style='margin-top:10px;' for=\"g\">G:</label>\n\
                        \   <input style='margin-top:10px;' type=\"number\" name=\"g\" min=\"0\" max=\"255\" required /><br>\n\
                        \   <label style='margin-top:10px;' for=\"b\">B:</label>\n\
                        \   <input style='margin-top:10px;' type=\"number\" name=\"b\" min=\"0\" max=\"255\" required /><br>\n\
                        \   <input type=\"hidden\" name=\"randomR\" value=\"" ++ show (r randomColor) ++ "\" />\n\
                        \   <input type=\"hidden\" name=\"randomG\" value=\"" ++ show (g randomColor) ++ "\" />\n\
                        \   <input type=\"hidden\" name=\"randomB\" value=\"" ++ show (b randomColor) ++ "\" />\n\
                        \   <input style='width:200px; padding:10px;margin-top:10px; background-color: "++ randomColorStyle ++";' type=\"submit\" value=\"Enviar\" />\n\
                        \</form>\n\
                        \</div>"
        html $ T.pack formHtml  -- Convertendo formHtml para Text

    post "/submit" $ do
        -- Captura os valores RGB do input do usuário
        rValue <- param "r"
        gValue <- param "g"
        bValue <- param "b"

        -- Captura a cor aleatória original enviada como campo oculto
        randomR <- param "randomR"
        randomG <- param "randomG"
        randomB <- param "randomB"

        -- Cria as cores do usuário e a aleatória
        let userColor = RGB rValue gValue bValue
        let randomColor = RGB randomR randomG randomB

        -- Calcula a pontuação com base na diferença entre as cores
        let score = calculateScore userColor randomColor

        -- Cria a string de estilo para a cor aleatória
        let randomColorStyle = rgbToStyle randomColor
        let userColorStyle = rgbToStyle userColor

        -- HTML para mostrar os resultados e a pontuação
        let resultHtml = 
                 "<div style='display: flex; flex-direction: column; align-items: center; justify-content: center; width:99%; height:98vh; background-color: gray; '>"++
                 "<div style='width: 100px; height: 100px; margin-top: 10px; margin-left:20px; background-color: " ++ randomColorStyle ++ ";'></div>" ++
                 "<div style='width: 100px; height: 100px; margin-top: 10px; margin-left:20px;  background-color: " ++ userColorStyle ++ ";'></div>" ++
                 "<p style='margin-top: 10px; margin-left:20px;'>Sua cor: " ++ show userColor ++ "</p>" ++
                 "<p style='margin-top: 10px; margin-left:20px;'>Cor sorteada: " ++ show randomColor ++ "</p>" ++
                 "<p style='margin-top: 10px; margin-left:20px;'>As cores são iguais? " ++ show (userColor == randomColor) ++ "</p>" ++
                 "<p style='margin-top: 10px; margin-left:20px;'>Pontuação: " ++ show score ++ " / 100</p>" ++
                 "<form style='margin-top: 10px; margin-left:20px;' action=\"/\" method=\"get\">\n" ++
                 "    <input type=\"submit\" value=\"Jogar Novamente\" style='border:none; color:white; cursor:pointer: width:200px; padding:8px; background-color: "++ randomColorStyle ++ ";' />\n" ++
                 "</form>"++
                 "</div>"

        
        -- Responde com os resultados
        html $ T.pack resultHtml  -- Convertendo resultHtml para Text
