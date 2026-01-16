import SwiftUI

struct User: Codable {
    let name: String
    let fund: Int
    let age: Int
    let family: Bool
}

struct UsersResponse: Codable {
    let data: [User]
}

struct ContentVie: View {
    @State private var users: [User] = []

    var body: some View {
        VStack(spacing: 20) {
            
            if users.isEmpty {
                Text("Waiting...")
            } else {
                ForEach(users, id: \.name) { user in
                    VStack(alignment: .leading) {
                        Text(user.name).font(.title3)
                        Text("Fund: \(user.fund)")
                        Text("Age: \(user.age)")
                        Text(user.family ? "Family" : "Single")
                        Divider()
                    }
                }
            }

            Button("Test API with Key") {
                testAPI()
            }
        }
        .padding()
    }

    func testAPI() {
        guard let url = URL(string: "http://127.0.0.1:8000/ping") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("TEST123", forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Network error:", error.localizedDescription)
                    users = []
                    return
                }

                guard let data = data else {
                    print("No data")
                    users = []
                    return
                }
                
                do{
                    let get = try JSONDecoder().decode(UsersResponse.self, from: data)
                    users = get.data
                }catch{
                    print("Error")
                    users = []
                }

               
            }
        }.resume()
    }
}

#Preview {
    ContentVie()
}
