require 'spec_helper'

module CorreiosSigep
  module LogisticReverse
    describe RequestCollectNumber do
      let(:logistic_reverse) { Models::LogisticReverse.new }
      let(:request_collect) { described_class.new logistic_reverse }

      before do
        seed_logistic_reverse(logistic_reverse)
        stub_request(:get, "http://webservicescolhomologacao.correios.com.br/ScolWeb/WebServiceScol?wsdl").
                   with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Ruby'}).
                   to_return(:status => 200, :body => correios_fixture('wsdl.xml'), :headers => {})
      end

      describe '.process' do
        subject { request_collect.process }

        context 'with success response' do
          it 'should return the collect number' do
            stub_request(:post, "http://webservicescolhomologacao.correios.com.br/ScolWeb/WebServiceScol").
                       with(:body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://webservice.scol.correios.com.br/\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\"><env:Body><tns:solicitarPostagemReversa><cartao>0057018901</cartao><codigo_servico>41076</codigo_servico><contrato>9912208555</contrato><codAdministrativo>08082650</codAdministrativo><senha>8o8otn</senha><usuario>60618043</usuario>\n  <destinatario>\n    <nome>ESTABELECIMENT W*M</nome>\n    <logradouro>ESTRADA DE ACESSO A JANDIRA</logradouro>\n    <numero>1400</numero>\n    <complemento>G4</complemento>\n    <bairro>FAZENDA ITAQUI</bairro>\n    <referencia>REFERENCE</referencia>\n    <cidade>BARUERI</cidade>\n    <uf>SP</uf>\n    <cep>06442130</cep>\n    <ddd>11</ddd>\n    <telefone>21683228</telefone>\n    <email>teste@example.com</email>\n  </destinatario>\n  <coletas_solicitadas>\n    <tipo>CA</tipo>\n    <id_cliente>1405670</id_cliente>\n    <valor_declarado>100.5</valor_declarado>\n    <descricao>teste</descricao>\n    <cklist>cklist</cklist>\n    <numero>1</numero>\n    <ag>1</ag>\n    <cartao>1234</cartao>\n    <servico_adicional>20.5</servico_adicional>\n    <ar>2</ar>\n    <remetente>\n      <nome>JEFERSON VAZ DOS SANTOS</nome>\n      <logradouro>RUA BLA BLA BLA</logradouro>\n      <numero>666</numero>\n      <complemento>APT 100</complemento>\n      <bairro>PINHEIROS</bairro>\n      <reference>REFERENCE</reference>\n      <cidade>S&#xC3;O PAULO</cidade>\n      <uf>SP</uf>\n      <cep>05427020</cep>\n      <ddd>16</ddd>\n      <telefone>41606809</telefone>\n      <email>jeff@example.com</email>\n      <identificacao/>\n      <ddd_celular/>\n      <celular/>\n      <sms/>\n    </remetente>\n    <produto>\n      <codigo>code</codigo>\n      <tipo>type</tipo>\n      <qtd>3</qtd>\n    </produto>\n    <obj_col>\n      <obj>\n        <item>127078</item>\n        <id>1405670</id>\n        <desc>Pen Drive SAndisk 16GB SDCZ50-016G-A95</desc>\n        <ship>ship</ship>\n        <num>1</num>\n      </obj>\n      <obj>\n        <item>277574</item>\n        <id>1405670</id>\n        <desc>Chip unico claro Pre pago</desc>\n        <ship>ship</ship>\n        <num>2</num>\n      </obj>\n    </obj_col>\n  </coletas_solicitadas>\n\n</tns:solicitarPostagemReversa></env:Body></env:Envelope>",
                                         :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'2306', 'Content-Type'=>'text/xml;charset=UTF-8', 'Soapaction'=>'"solicitarPostagemReversa"', 'User-Agent'=>'Ruby'}).
                       to_return(:status => 200, :body => correios_fixture('response_success.xml'), :headers => {})

            expect(subject).to eq '373533437'
          end
        end

        context 'with ticket already in use' do
          it 'should raise TicketAlreadyUsed error' do
            stub_request(:post, "http://webservicescolhomologacao.correios.com.br/ScolWeb/WebServiceScol").
                       with(:body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://webservice.scol.correios.com.br/\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\"><env:Body><tns:solicitarPostagemReversa><cartao>0057018901</cartao><codigo_servico>41076</codigo_servico><contrato>9912208555</contrato><codAdministrativo>08082650</codAdministrativo><senha>8o8otn</senha><usuario>60618043</usuario>\n  <destinatario>\n    <nome>ESTABELECIMENT W*M</nome>\n    <logradouro>ESTRADA DE ACESSO A JANDIRA</logradouro>\n    <numero>1400</numero>\n    <complemento>G4</complemento>\n    <bairro>FAZENDA ITAQUI</bairro>\n    <referencia>REFERENCE</referencia>\n    <cidade>BARUERI</cidade>\n    <uf>SP</uf>\n    <cep>06442130</cep>\n    <ddd>11</ddd>\n    <telefone>21683228</telefone>\n    <email>teste@example.com</email>\n  </destinatario>\n  <coletas_solicitadas>\n    <tipo>CA</tipo>\n    <id_cliente>1405670</id_cliente>\n    <valor_declarado>100.5</valor_declarado>\n    <descricao>teste</descricao>\n    <cklist>cklist</cklist>\n    <numero>1</numero>\n    <ag>1</ag>\n    <cartao>1234</cartao>\n    <servico_adicional>20.5</servico_adicional>\n    <ar>2</ar>\n    <remetente>\n      <nome>JEFERSON VAZ DOS SANTOS</nome>\n      <logradouro>RUA BLA BLA BLA</logradouro>\n      <numero>666</numero>\n      <complemento>APT 100</complemento>\n      <bairro>PINHEIROS</bairro>\n      <reference>REFERENCE</reference>\n      <cidade>S&#xC3;O PAULO</cidade>\n      <uf>SP</uf>\n      <cep>05427020</cep>\n      <ddd>16</ddd>\n      <telefone>41606809</telefone>\n      <email>jeff@example.com</email>\n      <identificacao/>\n      <ddd_celular/>\n      <celular/>\n      <sms/>\n    </remetente>\n    <produto>\n      <codigo>code</codigo>\n      <tipo>type</tipo>\n      <qtd>3</qtd>\n    </produto>\n    <obj_col>\n      <obj>\n        <item>127078</item>\n        <id>1405670</id>\n        <desc>Pen Drive SAndisk 16GB SDCZ50-016G-A95</desc>\n        <ship>ship</ship>\n        <num>1</num>\n      </obj>\n      <obj>\n        <item>277574</item>\n        <id>1405670</id>\n        <desc>Chip unico claro Pre pago</desc>\n        <ship>ship</ship>\n        <num>2</num>\n      </obj>\n    </obj_col>\n  </coletas_solicitadas>\n\n</tns:solicitarPostagemReversa></env:Body></env:Envelope>",
                                         :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'2306', 'Content-Type'=>'text/xml;charset=UTF-8', 'Soapaction'=>'"solicitarPostagemReversa"', 'User-Agent'=>'Ruby'}).
                       to_return(:status => 200, :body => correios_fixture('response_already_in_use.xml'), :headers => {})

            expect{subject}.to raise_error(Models::Errors::TicketAlreadyUsed)
          end
        end

        context 'when service is unavailable' do
          it 'should raise UnvailableService error' do
            stub_request(:post, "http://webservicescolhomologacao.correios.com.br/ScolWeb/WebServiceScol").
                       with(:body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?><env:Envelope xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:tns=\"http://webservice.scol.correios.com.br/\" xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\"><env:Body><tns:solicitarPostagemReversa><cartao>0057018901</cartao><codigo_servico>41076</codigo_servico><contrato>9912208555</contrato><codAdministrativo>08082650</codAdministrativo><senha>8o8otn</senha><usuario>60618043</usuario>\n  <destinatario>\n    <nome>ESTABELECIMENT W*M</nome>\n    <logradouro>ESTRADA DE ACESSO A JANDIRA</logradouro>\n    <numero>1400</numero>\n    <complemento>G4</complemento>\n    <bairro>FAZENDA ITAQUI</bairro>\n    <referencia>REFERENCE</referencia>\n    <cidade>BARUERI</cidade>\n    <uf>SP</uf>\n    <cep>06442130</cep>\n    <ddd>11</ddd>\n    <telefone>21683228</telefone>\n    <email>teste@example.com</email>\n  </destinatario>\n  <coletas_solicitadas>\n    <tipo>CA</tipo>\n    <id_cliente>1405670</id_cliente>\n    <valor_declarado>100.5</valor_declarado>\n    <descricao>teste</descricao>\n    <cklist>cklist</cklist>\n    <numero>1</numero>\n    <ag>1</ag>\n    <cartao>1234</cartao>\n    <servico_adicional>20.5</servico_adicional>\n    <ar>2</ar>\n    <remetente>\n      <nome>JEFERSON VAZ DOS SANTOS</nome>\n      <logradouro>RUA BLA BLA BLA</logradouro>\n      <numero>666</numero>\n      <complemento>APT 100</complemento>\n      <bairro>PINHEIROS</bairro>\n      <reference>REFERENCE</reference>\n      <cidade>S&#xC3;O PAULO</cidade>\n      <uf>SP</uf>\n      <cep>05427020</cep>\n      <ddd>16</ddd>\n      <telefone>41606809</telefone>\n      <email>jeff@example.com</email>\n      <identificacao/>\n      <ddd_celular/>\n      <celular/>\n      <sms/>\n    </remetente>\n    <produto>\n      <codigo>code</codigo>\n      <tipo>type</tipo>\n      <qtd>3</qtd>\n    </produto>\n    <obj_col>\n      <obj>\n        <item>127078</item>\n        <id>1405670</id>\n        <desc>Pen Drive SAndisk 16GB SDCZ50-016G-A95</desc>\n        <ship>ship</ship>\n        <num>1</num>\n      </obj>\n      <obj>\n        <item>277574</item>\n        <id>1405670</id>\n        <desc>Chip unico claro Pre pago</desc>\n        <ship>ship</ship>\n        <num>2</num>\n      </obj>\n    </obj_col>\n  </coletas_solicitadas>\n\n</tns:solicitarPostagemReversa></env:Body></env:Envelope>",
                                         :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Content-Length'=>'2306', 'Content-Type'=>'text/xml;charset=UTF-8', 'Soapaction'=>'"solicitarPostagemReversa"', 'User-Agent'=>'Ruby'}).
                       to_return(:status => 200, :body => correios_fixture('response_unavailable_service.xml'), :headers => {})

            expect{subject}.to raise_error(Models::Errors::UnavailableService)
          end
        end

      end
    end
  end
end
