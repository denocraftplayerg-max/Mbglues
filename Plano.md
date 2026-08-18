#include <iostream>
#include <fstream>
#include <string>
#include <regex>
#include <sstream>

// Função que aplica todas as otimizações do script Python de forma síncrona
std::string otimizarGLSL(const std::string& codigoBruto) {
    std::string codigo = codigoBruto;

    // 1. Rebaixar Precisão Global (highp -> mediump) para poupar Cache da GPU
    codigo = std::regex_replace(codigo, std::regex(r"\bhighp\b"), "mediump");

    // 2. Substituir pow(x, 2.0) ou pow(x, 2) por multiplicação direta (x * x)
    // Isso elimina o cálculo de potências exponenciais na GPU
    codigo = std::regex_replace(codigo, std::regex(r"\bpow\s*\(\s*([^,]+)\s*,\s*2(?:\.0)?\s*\)"), "((\\1)*(\\1))");

    // 3. Substituir divisões por raiz (/ sqrt(x)) pelo inverso multiplicativo (* inversesqrt(x))
    // O hardware das GPUs mobile processa inversesqrt em ciclos de clock mínimos
    codigo = std::regex_replace(codigo, std::regex(r"/\s*sqrt\s*\(\s*([^)]+)\s*\)"), "* inversesqrt($1)");

    // 4. Converter condicionais inline simples de limite inferior em funções max() nativas
    // Exemplo: if (x < 0.0) x = 0.0;  ->  x = max(x, 0.0); (Evita branching na GPU)
    codigo = std::regex_replace(codigo, std::regex(r"if\s*\(\s*([^<]+)\s*<\s*0\.0\s*\)\s*\1\s*=\s*0\.0\s*;"), "\\1 = max(\\1, 0.0);");

    return codigo;
}

int main() {
    std::string caminhoEntrada = "/storage/emulated/0/MG/glsl_cache.tmp";
    std::string caminhoBackup = "/storage/emulated/0/MG/glsl_cache.tmp.bak";

    // 1. Ler o arquivo de cache original
    std::ifstream arquivoEntrada(caminhoEntrada);
    if (!arquivoEntrada.is_open()) {
        std::cerr << "Erro: Nao foi possivel abrir o arquivo " << caminhoEntrada << std::endl;
        return 1;
    }

    std::stringstream buffer;
    buffer << arquivoEntrada.rdbuf();
    std::string conteudoOriginal = buffer.str();
    arquivoEntrada.close();

    // 2. Criar um Backup de segurança automático (.bak)
    std::ofstream arquivoBackup(caminhoBackup);
    if (arquivoBackup.is_open()) {
        arquivoBackup << conteudoOriginal;
        arquivoBackup.close();
        std::cout << "📦 Backup de seguranca criado em: " << caminhoBackup << std::endl;
    }

    // 3. Executar as otimizações matemáticas em lote
    std::cout << "⚡ Processando e otimizando o codigo fonte GLSL em C++..." << std::endl;
    std::string conteudoOtimizado = otimizarGLSL(conteudoOriginal);

    // 4. Gravar o resultado de volta no arquivo original .tmp
    std::ofstream arquivoSaida(caminhoEntrada);
    if (!arquivoSaida.is_open()) {
        std::cerr << "Erro: Nao foi possivel gravar no arquivo original." << std::endl;
        return 1;
    }
    arquivoSaida << conteudoOtimizado;
    arquivoSaida.close();

    std::cout << "🎉 Otimizacao C++ concluida! O arquivo glsl_cache.tmp foi atualizado." << std::endl;
    return 0;
}


